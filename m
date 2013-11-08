Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3KHQW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:22:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab3KHQWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:22:55 -0500
Date: Fri, 8 Nov 2013 17:24:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes: Fix the memory out of bound overwrite in
	copy_insn()
Message-ID: <20131108162415.GA27502@redhat.com>
References: <20131106191913.GA18661@redhat.com> <20131107075151.GB31560@gmail.com> <20131107143432.GA6240@redhat.com> <20131107151601.GA5163@gmail.com> <20131107162736.GA31834@redhat.com> <20131107194010.GA29154@redhat.com> <20131107194032.GB29154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107194032.GB29154@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07, Oleg Nesterov wrote:
>
> Note: we do not care if offset + size > i_size, the users of
> arch_uprobe->insn can't know how many bytes were actually copied
> anyway. But perhaps this needs more changes.

I guess this not is not very clear...

What I tried to say. Suppose that offset == 0 and i_size = 1.
In this case we still copy MAX_UINSN_BYTES into arch.insn
because the task gets the same page after page fault anyway,
and we can't inform arch_uprobe_analyze_insn() that we have
only read 1 byte. So this doesn't matter.

I changed this as follows:

	Note: we do not care if we read extra bytes after inode->i_size
	if we got the valid page. This is fine because the task gets the
	same page after page-fault, and arch_uprobe_analyze_insn() can't
	know how how many bytes were actually read anyway.

I also moved the comment up, before the main loop.

Srikar, I am going to add this to my tree unless you object now.
I verified that this indeed fixes the crash and the code looks
"obviously correct, see below.

Oleg.

static int __copy_insn(struct address_space *mapping, struct file *filp,
			void *insn, int nbytes, loff_t offset)
{
	struct page *page;

	if (!mapping->a_ops->readpage)
		return -EIO;
	/*
	 * Ensure that the page that has the original instruction is
	 * populated and in page-cache.
	 */
	page = read_mapping_page(mapping, offset >> PAGE_CACHE_SHIFT, filp);
	if (IS_ERR(page))
		return PTR_ERR(page);

	copy_from_page(page, offset, insn, nbytes);
	page_cache_release(page);

	return 0;
}

static int copy_insn(struct uprobe *uprobe, struct file *filp)
{
	struct address_space *mapping = uprobe->inode->i_mapping;
	loff_t offs = uprobe->offset;
	void *insn = uprobe->arch.insn;
	int size = MAX_UINSN_BYTES;
	int len, err = -EIO;

	/* Copy only available bytes, -EIO if nothing was read */
	do {
		if (offs >= i_size_read(uprobe->inode))
			break;

		len = min_t(int, size, PAGE_SIZE - (offs & ~PAGE_MASK));
		err = __copy_insn(mapping, filp, insn, len, offs);
		if (err)
			break;

		insn += len;
		offs += len;
		size -= len;
	} while (size);

	return err;
}

