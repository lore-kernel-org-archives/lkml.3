Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbbAMSyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:54:09 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:51232 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbAMSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:54:06 -0500
Message-ID: <54B569CB.8030003@android.com>
Date: Tue, 13 Jan 2015 10:54:03 -0800
From: Mark Salyzyn <salyzyn@android.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 3/3] pstore: add pmsg
References: <1420566565-30531-1-git-send-email-salyzyn@android.com> <CAGXu5j+ESkVaz4S6X_JbcADP1174bgRH1+qdPYiYX8E8von3Vg@mail.gmail.com>
In-Reply-To: <CAGXu5j+ESkVaz4S6X_JbcADP1174bgRH1+qdPYiYX8E8von3Vg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 09:58 AM, Kees Cook wrote:
> On Tue, Jan 6, 2015 at 9:49 AM, Mark Salyzyn <salyzyn@android.com> wrote:
>> A secured user-space accessible pstore object. Writes
>> to /dev/pmsg0 are appended to the buffer, on reboot
>> the persistent contents are available in
>> /sys/fs/pstore/pmsg-ramoops-[ID].
>>
>> One possible use is syslogd, or other daemon, can
>> write messages, then on reboot provides a means to
>> triage user-space activities leading up to a panic
>> as a companion to the pstore dmesg or console logs.
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>> ---
>>   fs/pstore/Kconfig          |  10 +++++
>>   fs/pstore/Makefile         |   2 +
>>   fs/pstore/inode.c          |   3 ++
>>   fs/pstore/internal.h       |   6 +++
>>   fs/pstore/platform.c       |   1 +
>>   fs/pstore/pmsg.c           | 101 +++++++++++++++++++++++++++++++++++++++++++++
>>   fs/pstore/ram.c            |  46 ++++++++++++++++++---
>>   include/linux/pstore.h     |   1 +
>>   include/linux/pstore_ram.h |   1 +
>>   9 files changed, 166 insertions(+), 5 deletions(-)
>>   create mode 100644 fs/pstore/pmsg.c
>>
. . .
>> diff --git a/fs/pstore/pmsg.c b/fs/pstore/pmsg.c
>> new file mode 100644
>> index 0000000..d50d818
>> --- /dev/null
>> +++ b/fs/pstore/pmsg.c
. . .
>> +static ssize_t write_pmsg(struct file *file, const char __user *buf,
>> +                         size_t count, loff_t *ppos)
>> +{
>> +       size_t i;
>> +
>> +       if (!count)
>> +               return 0;
>> +
>> +       if (!access_ok(VERIFY_READ, buf, count))
>> +               return -EFAULT;
>> +
>> +       for (i = 0; i < count; ) {
>> +               char buffer[512];
> This feels like a lot of stack space to use for a buffer. Would it
> maybe be better to either reduce the copy size or use a larger kmalloc
> or vmalloc buffer to act as the bounce buffer to pass to write_buf?
I am taking a page(sic) from kernel/printk/printk.c and countless 
drivers that have settled on 512 byte on-stack bounce buffers as an 
acceptable median. I will test vmalloc though since it would offer us 
the promise of a more atomic operation (see below).

. . .
>> +       if (IS_ERR(pmsg_device)) {
>> +               pr_err("pmsg: failed to create device\n");
> Instead of mentioning pmsg directly here and in the pr_err()s above,
> maybe set it via the pr_* defines:
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> And maybe use KBUILD_MODNAME instead of PMSG_NAME or vice versa?

Thanks :-)
> +static bool prz_ok(struct persistent_ram_zone *prz)
> +{
> +       return !!prz && !!(persistent_ram_old_size(prz) +
> +                          persistent_ram_ecc_string(prz, NULL, 0));
> +}
> The addition of prz_ok() seems like a separate change?
Will split out.

. . .
> Some nits above. Overall, this seems like a fine idea. Would it make
> sense to enforce a single opener for these writes to avoid
> interleaving?

I expect logging would favour lowest overhead. A reduced syscall 
approach would be for multiple writers to hold on to an open file 
descriptor. We can avoid the problem by switching to spinlock of the 
write handler to guarantee atomic. This makes a switch from stack bounce 
buffer to vmalloc advised.
>
> -Kees
Thanks. Expect a respin of the entire pstore pmsg patch-set story after 
testing.

Sincerely -- Mark Salyzyn
