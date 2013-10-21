Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3JUWYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3JUWYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:24:45 -0400
Message-ID: <5265A9A4.2000100@redhat.com>
Date: Mon, 21 Oct 2013 18:24:36 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        herrmann.der.user@googlemail.com, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>	<1382304926-1641-2-git-send-email-prarit@redhat.com> <CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
In-Reply-To: <CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/21/2013 08:24 AM, Ming Lei wrote:
> On Mon, Oct 21, 2013 at 5:35 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>> If request_firmware_nowait() is called with uevent == NULL, the firmware
>> completion is never marked complete resulting in a hang in the process.
>>
>> If uevent is undefined, that means we're not waiting on anything and the
>> process should just clean up and complete.  While we're at it, add a
>> debug dev_dbg() to indicate that the FW has not been found.
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: x86@kernel.org
>> Cc: herrmann.der.user@googlemail.com
>> Cc: ming.lei@canonical.com
>> Cc: tigran@aivazian.fsnet.co.uk
>> ---
>>  drivers/base/firmware_class.c |    6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index 10a4467..95778dc 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -335,7 +335,8 @@ static bool fw_get_filesystem_firmware(struct device *device,
>>                 set_bit(FW_STATUS_DONE, &buf->status);
>>                 complete_all(&buf->completion);
>>                 mutex_unlock(&fw_lock);
>> -       }
>> +       } else
>> +               dev_dbg(device, "firmware: %s not found\n", buf->fw_id);
>>
>>         return success;
>>  }
>> @@ -886,6 +887,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>>                         schedule_delayed_work(&fw_priv->timeout_work, timeout);
>>
>>                 kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
>> +       } else {
>> +               /* if there is no uevent then just cleanup */
>> +               schedule_delayed_work(&fw_priv->timeout_work, 0);
>>         }
> 
> This may not a good idea and might break current NOHOTPLUG
> users, 

Ming,

The code is broken for all callers of request_firmware_nowait() with NOHOTPLUG
and CONFIG_FW_LOADER_USER_HELPER=y.  AFAICT with the two existing cases of this
usage in the kernel, both are broken and both are attempting to do the same
thing that I'm doing in the x86 microcode ATM.

This is the situation as I understand it and please correct me if I'm wrong
about the execution path.  If I call request_firmware_nowait() with NOHOTPLUG I
am essentially saying that there is no uevent associated with this firmware
load; that is uevent = 0.  request_firmware_work_func() is called as scheduled
task, which results in a call to _request_firmware().  _request_firmware() first
calls _request_firmware_prepare() which eventually results in a call to
__allocate_fw_buf() which does an init_completion(&buf->completion).

Returning back up the stack to _request_firmware() we eventually call
fw_get_filesystem_firmware().  _If the firmware does not exist_ success is false
and the if (success) loop is not executed, and it is important to note that the
complete_all(&buf->completion) is _not_ called.  fw_get_filesystem_firmware()
returns an error so that fw_load_from_user_helper() is called from
_request_firmware().

fw_load_from_user_helper() eventually calls _request_firmware_load() and this is
where we get into a problem.  fw_load_from_user_helper() calls all the file
creation, etc., and then hits this chunk of code:

        if (uevent) {
                dev_set_uevent_suppress(f_dev, false);
                dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
                if (timeout != MAX_SCHEDULE_TIMEOUT)
                        schedule_delayed_work(&fw_priv->timeout_work, timeout);

                kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
        }

        wait_for_completion(&buf->completion);

As I previously said, we've been called with NOHOTPLUG, ie) uevent = 0.  That
means we skip down to the wait_for_completion(&buf->completion) ... and we wait
... forever.

I can reproduce this by using a Dell PE 1850 & the dell_rbu module by doing the
following:

insmod dell_rbu.ko
echo init > /sys/devices/platform/dell_rbu/image_type
lsmod | grep dell_rbu

(after an hour)

[root@dell-pe1850-04 dell_rbu]# lsmod | grep dell_rbu
dell_rbu               14315  1
[root@dell-pe1850-04 dell_rbu]#

^^^ that use count is left because the thread is waiting with an existing module
ref count.  For kicks I put a printk in the dell_rbu code or instrument the
_request_firmware() code and did a reboot.  Since the completions are finished
on system shutdown, I see the code continue to execute at the end of boot.

> and how can you make sure the user space application can
> complete the request during the timeout time?

I see that your question really comes down to "are there additional
synchronizations needed in the two drivers that already call the code this way?"
 I realize that the answer to that is yes and I'll fix those up in a v2.  It
should be trivial to make those changes AFAICT.  I've introduced some additional
synchronization via a completion in the x86 microcode and will likely have to do
something similar in the other drivers ... although it may be easier to just
have the firmware code do all the synchronization.  I'll look into it.

Hope this explains things a bit better,

P.

> 
> Thanks,
> --
> Ming Lei
