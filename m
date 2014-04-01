Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaDAPPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:15:35 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:45862 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaDAPPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140401103617.GA10882@node.dhcp.inet.fi>
References: <20140331211607.26784.43976.stgit@zurg>
	<20140401103617.GA10882@node.dhcp.inet.fi>
Date: Tue, 1 Apr 2014 19:15:31 +0400
Message-ID: <CALYGNiPvZSg7_b47+TbjhTzt0vBSRiXN8edVH=9A3YJOMQMqjA@mail.gmail.com>
Subject: Re: [PATCH RFC] drivers/char/mem: byte generating devices and
 poisoned mappings
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Yury Gribov <y.gribov@samsung.com>,
        Alexandr Andreev <aandreev@parallels.com>,
        Vassili Karpov <av1474@comtv.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 2:36 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> On Tue, Apr 01, 2014 at 01:16:07AM +0400, Konstantin Khlebnikov wrote:
>> This patch adds 256 virtual character devices: /dev/byte0, ..., /dev/byte255.
>> Each works like /dev/zero but generates memory filled with particular byte.
>
> Shouldn't /dev/byte0 be an alias for /dev/zero?
> I see you reuse ZERO_PAGE(0) for that, but what about all these special
> cases /dev/zero has?

What special cases? I found rss-accounting part, you've mentioned coredump.

>
>> Features/use cases:
>> * handy source of non-zero bytes for 'dd' (dd if=/dev/byte1 ...)
>> * effective way for allocating poisoned memory (just mmap, without memset)
>> * /dev/byte42 is full of stars (*)
>>
>> Memory filled by default with non-zero bytes might help optimize logic in some
>> applications. For example (according to Yury Gribov) Address Sanitizer generates
>> additional conditional jump for each memory access just to handle default zero
>> byte as '0x8' to avoid memset`ing huge shadow memory map at the beginning.
>> In this case allocating memory via mapping /dev/byte8 will reduce size and
>> overhead of instrumented code without adding any memory usage overhead.
>>
>> /dev/byteX devices have the same performance optimizations like /dev/zero.
>> Shared read-only pages are allocated lazily at the first request and freed by
>> the memory shrinker (design inspired by huge-zero-page). Private mappings are
>> organized as normal anonymous mappings with special page-fault handler which
>> allocates, initializes and installs pages like do_anonymous_page().
>>
>> Unlike to /dev/zero shared ro-pages are installed into PTEs as normal pages and
>> accounted into file-RSS: vm_normal_page() allows only zero-page to be installed
>> as 'special'. This difference is fixable, but I don't see why it's matters.
>
> One thing that could surprise is unexpectedly big core dump files caused
> by /dev/byteX mappings. We have special handling for FOLL_DUMP && zero_page.
> Not sure if /dev/byteX should be handled this way too.

Seems like it should be. There is no reason for dumping it.

>
>> This patch also (mostly) implements effective non-zero-filled shmem/tmpfs files,
>> (they are used for shared mappings) but here is no interface for the userspace.
>> This feature mught be exported as ioctl or fcntl call.
>>
>> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>> Cc: Alexandr Andreev <aandreev@parallels.com>
>> Cc: Vassili Karpov <av1474@comtv.ru>
>> Cc: Yury Gribov <y.gribov@samsung.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> ---
>>  drivers/char/Kconfig     |    7 +
>>  drivers/char/mem.c       |  285 ++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/shmem_fs.h |    4 +
>>  mm/shmem.c               |   58 ++++++++-
>>  4 files changed, 346 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
>> index 1386749..e52cb4e 100644
>> --- a/drivers/char/Kconfig
>> +++ b/drivers/char/Kconfig
>> @@ -15,6 +15,13 @@ config DEVKMEM
>>         kind of kernel debugging operations.
>>         When in doubt, say "N".
>>
>> +config DEVBYTES
>
> I don't think we want new option for this.
>
>> +     bool "Byte generating devices"
>> +     depends on SHMEM
>> +     help
>> +       This option adds 256 virual devices similar to /dev/zero,
>> +       one for each byte value: /dev/byte0, /dev/byte1, ..., /dev/byte255.
>> +
>
> ...
>
>> +static ssize_t byte_read(struct file *file, char __user *buf,
>> +                      size_t count, loff_t *ppos)
>> +{
>> +     unsigned byte = (unsigned long)file->private_data;
>> +     size_t written;
>> +
>> +     if (!count)
>> +             return 0;
>> +
>> +     if (!access_ok(VERIFY_WRITE, buf, count))
>> +             return -EFAULT;
>> +
>> +     written = 0;
>> +     while (count) {
>> +             size_t chunk = min(count, PAGE_SIZE);
>> +
>> +             if (__memset_user(buf, byte, chunk))
>> +                     return -EFAULT;
>> +             if (signal_pending(current))
>> +                     return written ? written : -ERESTARTSYS;
>> +             written += chunk;
>> +             buf += chunk;
>> +             count -= chunk;
>> +             cond_resched();
>> +     }
>> +     return written;
>> +}
>
> Shouldn't this code be shared with read_zero()?

yep. it might be merged.

>
>> +
>> +static ssize_t byte_aio_read(struct kiocb *iocb, const struct iovec *iov,
>> +                          unsigned long nr_segs, loff_t pos)
>> +{
>> +     size_t written = 0;
>> +     unsigned long i;
>> +     ssize_t ret;
>> +
>> +     for (i = 0; i < nr_segs; i++) {
>> +             ret = byte_read(iocb->ki_filp, iov[i].iov_base, iov[i].iov_len,
>> +                             &pos);
>> +             if (ret < 0)
>> +                     break;
>> +             written += ret;
>> +     }
>> +
>> +     return written ? written : -EFAULT;
>> +}
>
> Ditto.
>
>> +
>> +static const struct file_operations byte_fops = {
>> +     .llseek         = byte_lseek,
>> +     .read           = byte_read,
>> +     .write          = byte_write,
>> +     .aio_read       = byte_aio_read,
>> +     .aio_write      = byte_aio_write,
>> +     .open           = byte_open,
>> +     .mmap           = byte_mmap,
>> +};
>> +
>> +static int __init byte_init(void)
>> +{
>> +     int major, minor;
>> +
>> +     major  = __register_chrdev(0, 0, 256, "byte", &byte_fops);
>> +     if (major < 0) {
>> +             printk("unable to get major for byte devs\n");
>
> Hm. Can we, instead of having 256 devnodes, have one /dev/byte?
> User can ask which byte it wants by write() byte to file descriptor before
> using it with zero by default.

In this case it wouldn't be usable for "dd" =)

poisoned mmap could be be done without devices at all,
mmap(MAP_ANONYMOUS) has plenty unused arguments. For example this
might looks like:
mmap(flags = MAP_ANONYMOUS | MAP_SHARED/PRIVATE | MAP_POISON, fd = poison)

>
> --
>  Kirill A. Shutemov
