Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaBCPLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:11:33 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:38333 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaBCPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4S6jCc4Kd2EKoG0SgSc68TrBBSfnKChGV6Tn3fGKGRnSQ@mail.gmail.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<1391316630-29541-8-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4S6jCc4Kd2EKoG0SgSc68TrBBSfnKChGV6Tn3fGKGRnSQ@mail.gmail.com>
Date: Mon, 3 Feb 2014 10:11:28 -0500
Message-ID: <CAN+gG=G3njr09E3Q_6kd1SSp5k-Wcn1+aeHee5-Q6tWwFtuA1w@mail.gmail.com>
Subject: Re: [PATCH 07/11] HID: HIDp: remove duplicated coded
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 10:02 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> - Move hidp_output_report() above
>> - Removed duplicated code in hidp_output_raw_report()
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  net/bluetooth/hidp/core.c | 68 ++++++++---------------------------------------
>>  1 file changed, 11 insertions(+), 57 deletions(-)
>>
>> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
>> index 469e61b..02670b3 100644
>> --- a/net/bluetooth/hidp/core.c
>> +++ b/net/bluetooth/hidp/core.c
>> @@ -373,62 +373,25 @@ err:
>>         return ret;
>>  }
>>
>> -static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data, size_t count,
>> -               unsigned char report_type)
>> +static int hidp_output_report(struct hid_device *hid, __u8 *data, size_t count)
>>  {
>>         struct hidp_session *session = hid->driver_data;
>> -       int ret;
>>
>> +       return hidp_send_intr_message(session,
>> +                                     HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT,
>> +                                     data, count);
>> +}
>> +
>> +static int hidp_output_raw_report(struct hid_device *hid, unsigned char *data,
>> +               size_t count, unsigned char report_type)
>> +{
>>         if (report_type == HID_OUTPUT_REPORT) {
>> -               report_type = HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT;
>> -               return hidp_send_intr_message(session, report_type,
>> -                                             data, count);
>> +               return hidp_output_report(hid, data, count);
>
> NAK, that does not work with BT. hidp_output_raw_report() can do both,
> a synchronous SET_REPORT and an async OUTPUT_REPORT. It's currently
> screwed up, as for RTYPE_OUTPUT it uses the intr-channel, for
> RTYPE_FEATURE the ctrl-channel.

David, please, re-review it carefully, and see that there is _no_
change in the code path with this refactoring:
hidp_output_report() calls exactly one hidp_send_intr_message() with
the same arguments.

And for the rest, you will see that the code path is still the same also.

>
> This function is exactly the reason why we added raw_report() and
> output_report(). So I'd like to keep it as it and just remove it once
> we have no more users of hidp_output_raw_report().

I worked on that yesterday, so I can make this happening soon (not
today though).

Cheers,
Benjamin

>
> Thanks
> David
>
>>         } else if (report_type != HID_FEATURE_REPORT) {
>>                 return -EINVAL;
>>         }
>>
>> -       if (mutex_lock_interruptible(&session->report_mutex))
>> -               return -ERESTARTSYS;
>> -
>> -       /* Set up our wait, and send the report request to the device. */
>> -       set_bit(HIDP_WAITING_FOR_SEND_ACK, &session->flags);
>> -       report_type = HIDP_TRANS_SET_REPORT | HIDP_DATA_RTYPE_FEATURE;
>> -       ret = hidp_send_ctrl_message(session, report_type, data, count);
>> -       if (ret)
>> -               goto err;
>> -
>> -       /* Wait for the ACK from the device. */
>> -       while (test_bit(HIDP_WAITING_FOR_SEND_ACK, &session->flags) &&
>> -              !atomic_read(&session->terminate)) {
>> -               int res;
>> -
>> -               res = wait_event_interruptible_timeout(session->report_queue,
>> -                       !test_bit(HIDP_WAITING_FOR_SEND_ACK, &session->flags)
>> -                               || atomic_read(&session->terminate),
>> -                       10*HZ);
>> -               if (res == 0) {
>> -                       /* timeout */
>> -                       ret = -EIO;
>> -                       goto err;
>> -               }
>> -               if (res < 0) {
>> -                       /* signal */
>> -                       ret = -ERESTARTSYS;
>> -                       goto err;
>> -               }
>> -       }
>> -
>> -       if (!session->output_report_success) {
>> -               ret = -EIO;
>> -               goto err;
>> -       }
>> -
>> -       ret = count;
>> -
>> -err:
>> -       clear_bit(HIDP_WAITING_FOR_SEND_ACK, &session->flags);
>> -       mutex_unlock(&session->report_mutex);
>> -       return ret;
>> +       return hidp_set_raw_report(hid, data[0], data, count, report_type);
>>  }
>>
>>  static int hidp_raw_request(struct hid_device *hid, unsigned char reportnum,
>> @@ -445,15 +408,6 @@ static int hidp_raw_request(struct hid_device *hid, unsigned char reportnum,
>>         }
>>  }
>>
>> -static int hidp_output_report(struct hid_device *hid, __u8 *data, size_t count)
>> -{
>> -       struct hidp_session *session = hid->driver_data;
>> -
>> -       return hidp_send_intr_message(session,
>> -                                     HIDP_TRANS_DATA | HIDP_DATA_RTYPE_OUPUT,
>> -                                     data, count);
>> -}
>> -
>>  static void hidp_idle_timeout(unsigned long arg)
>>  {
>>         struct hidp_session *session = (struct hidp_session *) arg;
>> --
>> 1.8.3.1
>>
