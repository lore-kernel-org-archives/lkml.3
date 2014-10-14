Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbaJNNQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:16:36 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:40629 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbaJNNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
	<20141014111915.GV23154@mwanda>
	<CD2CABCB2C0A0D4682C5F8AD840141540BFD19@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Tue, 14 Oct 2014 14:16:34 +0100
Message-ID: <CAL7Bo8ESE-=FY0KyQDc2Ne1SfX=fF0Q088jo_j-JpMmQYvArGg@mail.gmail.com>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is your expected value for TICK_USEC?  I cant make the arithmetic work.
You double the check time if you are close but you never reduce the
check time if you are not.
Adjusting the tick count is a coarse adjustment of the clock.  You
will end up chasing the host time but never stabilizing it.

Regarding the comment we have NTP for this I agree that would be
better than this implementation and I think Thomas agrees (as he said
NTP is the preferred option)
In order for this to be a good source of time for RTP and other time
sensitive stuff . you will have to have to re-implement parts of NTP
such as adjusting the clock frequency decreasing the check period when
error becomes too great etc. etc..

I still think there is a requirement for this if it is done more
comprehensively.  For example depending on CPU loading some Hyperv
guests can give a drift of greater than 500ppm which NTP cant cope
with.


On Tue, Oct 14, 2014 at 1:50 PM, Thomas Shao <huishao@microsoft.com> wrote:
>
>> -----Original Message-----
>> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
>> Sent: Tuesday, October 14, 2014 7:19 PM
>> To: Thomas Shao
>> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
>> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
>> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
>> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
>> time sample
>>
>> I had a couple small style nits.
>>
>> On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
>> > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c index
>> > 3b9c9ef..1d8390c 100644
>> > --- a/drivers/hv/hv_util.c
>> > +++ b/drivers/hv/hv_util.c
>> > @@ -51,11 +51,30 @@
>> >  #define HB_WS2008_MAJOR    1
>> >  #define HB_WS2008_VERSION  (HB_WS2008_MAJOR << 16 |
>> HB_MINOR)
>> >
>> > +#define  TIMESAMPLE_INTERVAL 5000000000L  /* 5s in nanosecond */
>>
>> If you wanted you could say:
>>
>> #define  TIMESAMPLE_INTERVAL  (5 * NSEC_PER_SEC)
>>
>> > +
>> > +/*host sends time sample for every 5s.So the max polling interval
>> > +*is 128*5 = 640s.
>> > +*/
>>
>> The comment still has problems throughout.  Read
>> Documentation/CodingStyle.
>>
>
> I will correct the style of the comment.
>
>> > +#define  TIME_ADJ_MAX_INTERVAL 128 /*Max polling interval */
>> > +
>> >  static int sd_srv_version;
>> >  static int ts_srv_version;
>> >  static int hb_srv_version;
>> >  static int util_fw_version;
>> >
>> > +/*host sends time sample for every 5s.So the initial polling interval
>> > +*is 5s.
>> > +*/
>> > +static s32 adj_interval = 1;
>>
>> Prefer mundane types instead there is a reason.  This should be int because
>> it's not specified in a hardware spec.  I know you are being consistent with
>> the surrounding code, but the surrounding code is bad so don't emulate it.
>>
> I agree with you. Maybe it's a good idea to correct the surrounding code in
> another patch.
>
>> > +
>> > +/*The host_time_sync module parameter is used to control the time
>> > +  sync between host and guest.
>> > +*/
>> > +static bool host_time_sync;
>> > +module_param(host_time_sync, bool, (S_IRUGO | S_IWUSR));
>> > +MODULE_PARM_DESC(host_time_sync, "If the guest sync time with
>> host");
>>
>> Maybe say: "Synchronize time with the host"?
>
> Sounds good.
>
>>
>> > +
>> >  static void shutdown_onchannelcallback(void *context);  static struct
>> > hv_util_service util_shutdown = {
>> >     .util_cb = shutdown_onchannelcallback, @@ -163,15 +182,61 @@
>> static
>> > void shutdown_onchannelcallback(void *context)
>> >  /*
>> >   * Set guest time to host UTC time.
>> >   */
>> > -static inline void do_adj_guesttime(u64 hosttime)
>> > +static inline void do_adj_guesttime(u64 hosttime, bool forceSync)
>>
>> I'm surprise checkpatch.pl does't complain about this CamelCase.
>
> I've run the scripts/checkpatch.pl, it didn't complain anything. I'll change to forcesync.
>
>>
>> regards,
>> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
