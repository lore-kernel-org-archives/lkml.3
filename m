Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3JVXPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab3JVXPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:15:18 -0400
Message-ID: <526706FC.2070105@redhat.com>
Date: Tue, 22 Oct 2013 19:15:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with
 no uevent
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>	<1382304926-1641-2-git-send-email-prarit@redhat.com>	<CACVXFVO_bbYsRRgZ+MfVKf5=VRNy=O3VUg0mh2fumEi7cObuiw@mail.gmail.com>	<5265A9A4.2000100@redhat.com> <CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>
In-Reply-To: <CACVXFVM7eKA2m+ten5-1EYNdJkc5SuZy2cimpH9j94OOdsb9Uw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 10:35 PM, Ming Lei wrote:
> On Tue, Oct 22, 2013 at 6:24 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>>
>>
>> On 10/21/2013 08:24 AM, Ming Lei wrote:
>>> On Mon, Oct 21, 2013 at 5:35 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>> If request_firmware_nowait() is called with uevent == NULL, the firmware
>>>> completion is never marked complete resulting in a hang in the process.
>>>>
>>>> If uevent is undefined, that means we're not waiting on anything and the
>>>> process should just clean up and complete.  While we're at it, add a
>>>> debug dev_dbg() to indicate that the FW has not been found.
>>>>
>>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>>> Cc: x86@kernel.org
>>>> Cc: herrmann.der.user@googlemail.com
>>>> Cc: ming.lei@canonical.com
>>>> Cc: tigran@aivazian.fsnet.co.uk
>>>> ---
>>>>  drivers/base/firmware_class.c |    6 +++++-
>>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>>>> index 10a4467..95778dc 100644
>>>> --- a/drivers/base/firmware_class.c
>>>> +++ b/drivers/base/firmware_class.c
>>>> @@ -335,7 +335,8 @@ static bool fw_get_filesystem_firmware(struct device *device,
>>>>                 set_bit(FW_STATUS_DONE, &buf->status);
>>>>                 complete_all(&buf->completion);
>>>>                 mutex_unlock(&fw_lock);
>>>> -       }
>>>> +       } else
>>>> +               dev_dbg(device, "firmware: %s not found\n", buf->fw_id);
>>>>
>>>>         return success;
>>>>  }
>>>> @@ -886,6 +887,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>>>>                         schedule_delayed_work(&fw_priv->timeout_work, timeout);
>>>>
>>>>                 kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
>>>> +       } else {
>>>> +               /* if there is no uevent then just cleanup */
>>>> +               schedule_delayed_work(&fw_priv->timeout_work, 0);
>>>>         }
>>>
>>> This may not a good idea and might break current NOHOTPLUG
>>> users,
>>
>> Ming,
>>
>> The code is broken for all callers of request_firmware_nowait() with NOHOTPLUG
>> and CONFIG_FW_LOADER_USER_HELPER=y.  AFAICT with the two existing cases of this
>> usage in the kernel, both are broken and both are attempting to do the same
>> thing that I'm doing in the x86 microcode ATM.
>>
>> This is the situation as I understand it and please correct me if I'm wrong
>> about the execution path.  If I call request_firmware_nowait() with NOHOTPLUG I
>> am essentially saying that there is no uevent associated with this firmware
>> load; that is uevent = 0.  request_firmware_work_func() is called as scheduled
>> task, which results in a call to _request_firmware().  _request_firmware() first
>> calls _request_firmware_prepare() which eventually results in a call to
>> __allocate_fw_buf() which does an init_completion(&buf->completion).
>>
>> Returning back up the stack to _request_firmware() we eventually call
>> fw_get_filesystem_firmware().  _If the firmware does not exist_ success is false
>> and the if (success) loop is not executed, and it is important to note that the
>> complete_all(&buf->completion) is _not_ called.  fw_get_filesystem_firmware()
>> returns an error so that fw_load_from_user_helper() is called from
>> _request_firmware().
>>
>> fw_load_from_user_helper() eventually calls _request_firmware_load() and this is
>> where we get into a problem.  fw_load_from_user_helper() calls all the file
>> creation, etc., and then hits this chunk of code:
>>
>>         if (uevent) {
>>                 dev_set_uevent_suppress(f_dev, false);
>>                 dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
>>                 if (timeout != MAX_SCHEDULE_TIMEOUT)
>>                         schedule_delayed_work(&fw_priv->timeout_work, timeout);
>>
>>                 kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
>>         }
>>
>>         wait_for_completion(&buf->completion);
>>
>> As I previously said, we've been called with NOHOTPLUG, ie) uevent = 0.  That
>> means we skip down to the wait_for_completion(&buf->completion) ... and we wait
>> ... forever.
> 
> Yes, it is exactly the previous design on NOHOTPLUG, because
> firmware loader has to wait for the handling from user space, and
> no one can predict when userspace comes because of no
> notification. For example, the userspace may be 'some inputting
> from shell by someone once he is free', :-) so it is difficult to set a
> timeout explicitly for the handling.
> 
> But the requests can be killed before suspend & shutdown, so
> it is still OK.
> 
> That is why NOHOTPLUG isn't encouraged to be taken, actually
> I don't suggest you to do that too, :-)
Okay ... I can certainly switch to HOTPLUG.

> 
> You need to make sure your approach won't break micro-code
> update application in current/previous distributions.

I've tested the following distributions today on a Dell PE 1850:  Ubuntu, SuSe,
Linux Mint, and of course Fedora.  I do not see any issues with either the
microcode update or the dell_rbu driver.  Unfortunately I do not have access to
a system that uses the lattice-ecp3-config, however, from code inspection it
looks like the driver looks at a specific place for the FW update and then
applies it via the call function in request_firmware_nowait() so it looks like
it is solid too.

I think maybe this patchset should be split into two separate submits, one for
the microcode and the second to figure out if the code really should wait
indefinitely.  AFAICT neither use case in the kernel expects an indefinite wait.

P.

> 
>>
>> I can reproduce this by using a Dell PE 1850 & the dell_rbu module by doing the
>> following:
>>
>> insmod dell_rbu.ko
>> echo init > /sys/devices/platform/dell_rbu/image_type
>> lsmod | grep dell_rbu
>>
>> (after an hour)
>>
>> [root@dell-pe1850-04 dell_rbu]# lsmod | grep dell_rbu
>> dell_rbu               14315  1
>> [root@dell-pe1850-04 dell_rbu]#
>>
>> ^^^ that use count is left because the thread is waiting with an existing module
>> ref count.  For kicks I put a printk in the dell_rbu code or instrument the
>> _request_firmware() code and did a reboot.  Since the completions are finished
>> on system shutdown, I see the code continue to execute at the end of boot.
> 
> Right, so no obvious problem from user view, isn't it?

Well, there is an issue that it is possible that the dell_rbu driver attempts to
load the update BEFORE the update is available.  I have written some additional
code to fix that.

P.
