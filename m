Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3FKNUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:20:24 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:53654 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3FKNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130610173739.4d88d4ec@holzheu>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-4-git-send-email-holzheu@linux.vnet.ibm.com>
	<CABOkKT0yk6tytN=aTSdpECQWw_30m5qrZYH-W1msovkeiSeZCA@mail.gmail.com>
	<20130610173739.4d88d4ec@holzheu>
Date: Tue, 11 Jun 2013 22:20:22 +0900
Message-ID: <CABOkKT3ir=bRAmD-pgQOsM_EfPsThtzVnhhY16e_A3suBe5sgg@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] vmcore: Introduce remap_oldmem_pfn_range()
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/11 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
> On Mon, 10 Jun 2013 22:40:24 +0900
> HATAYAMA Daisuke <d.hatayama@gmail.com> wrote:
>
>> 2013/6/8 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
>> <cut>
>> > @@ -225,6 +251,56 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
>> >         return acc;
>> >  }
>> >
>> > +static ssize_t read_vmcore(struct file *file, char __user *buffer,
>> > +                          size_t buflen, loff_t *fpos)
>> > +{
>> > +       return __read_vmcore(buffer, buflen, fpos, 1);
>> > +}
>> > +
>> > +/*
>> > + * The vmcore fault handler uses the page cache and fills data using the
>> > + * standard __vmcore_read() function.
>> > + */
>> > +static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> > +{
>> > +       struct address_space *mapping = vma->vm_private_data;
>> > +       pgoff_t index = vmf->pgoff;
>> > +       struct page *page;
>> > +       loff_t src;
>> > +       char *buf;
>> > +       int rc;
>> > +
>> > +find_page:
>> > +       page = find_lock_page(mapping, index);
>> > +       if (page) {
>> > +               unlock_page(page);
>> > +               rc = VM_FAULT_MINOR;
>> > +       } else {
>> > +               page = page_cache_alloc_cold(mapping);
>> > +               if (!page)
>> > +                       return VM_FAULT_OOM;
>> > +               rc = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
>> > +               if (rc) {
>> > +                       page_cache_release(page);
>> > +                       if (rc == -EEXIST)
>> > +                               goto find_page;
>> > +                       /* Probably ENOMEM for radix tree node */
>> > +                       return VM_FAULT_OOM;
>> > +               }
>> > +               buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);
>> > +               src = index << PAGE_CACHE_SHIFT;
>> > +               __read_vmcore(buf, PAGE_SIZE, &src, 0);
>> > +               unlock_page(page);
>> > +               rc = VM_FAULT_MAJOR;
>> > +       }
>> > +       vmf->page = page;
>> > +       return rc;
>> > +}
>>
>> How about reusing find_or_create_page()?
>
> The function would then look like the following:
>
> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> {
>         struct address_space *mapping = vma->vm_private_data;
>         pgoff_t index = vmf->pgoff;
>         struct page *page;
>         loff_t src;
>         char *buf;
>
>         page = find_or_create_page(mapping, index, GFP_KERNEL);
>         if (!page)
>                 return VM_FAULT_OOM;
>         src = index << PAGE_CACHE_SHIFT;
>         buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);
>         __read_vmcore(buf, PAGE_SIZE, &src, 0);

You should check return value of __read_vmcore() since this can fail.
Then, I think returning VM_FAULT_SIGBUS is correct.

>         unlock_page(page);
>         vmf->page = page;
>         return 0;
> }

Thanks.
HATAYAMA, Daisuke
