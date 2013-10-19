Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3JSQ6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3JSQ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:58:00 -0400
Date: Sat, 19 Oct 2013 18:50:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/13] uprobes: add arch write opcode hook
Message-ID: <20131019165051.GC7837@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-6-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381871068-27660-6-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, David Long wrote:
>
> Allow arches to write the opcode with a custom function.  ARM needs to
> customize the swbp instruction depending on the condition code of the
> instruction it replaces.

Well, we already have "__weak set_swbp(auprobe, ...)", can't arm use it?

If not,

> +void __weak arch_uprobe_write_opcode(struct arch_uprobe *auprobe, void *vaddr,
> +				     uprobe_opcode_t opcode)
> +{
> +	memcpy(vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
> +}
> ...
> -	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
> +	vaddr_new = kmap_atomic(new_page);
> +	arch_uprobe_write_opcode(auprobe, vaddr_new + (vaddr & ~PAGE_MASK),
> +				 opcode);
> +	kunmap_atomic(vaddr_new);

Again, if you need to add the new __weak helper, I think it should simply
do copy_to_page().

Oleg.

