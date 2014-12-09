Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaLIKap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:30:45 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:60081 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbaLIKan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:30:43 -0500
Message-ID: <1418121037.3641.22.camel@linaro.org>
Subject: Re: Re: [PATCH v14 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Wang Nan <wangnan0@huawei.com>, lizefan@huawei.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Tue, 09 Dec 2014 10:30:37 +0000
In-Reply-To: <5486CB9F.6030804@hitachi.com>
References: <1418020040-68977-1-git-send-email-wangnan0@huawei.com>
	 <1418020131-69375-1-git-send-email-wangnan0@huawei.com>
	 <1418036666.3647.33.camel@linaro.org> <5485886E.2060303@huawei.com>
	 <1418039451.3647.48.camel@linaro.org> <5486CB9F.6030804@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 19:14 +0900, Masami Hiramatsu wrote:
> (2014/12/08 20:50), Jon Medhurst (Tixy) wrote:> arch_optimize_kprobes is calling __arch_optimize_kprobes, which is
> > iterating over a list of probes and removing each one in turn, if this
> > is happening on multiple cpu's simultaneously, it's not clear to me that
> > such an operation is safe. list_del_init calls __list_del which does
> >
> > 	next->prev = prev;
> > 	prev->next = next;
> >
> > so what happens if another cpu is at the same time updating any of those
> > list entries? Without even fully analysing the code I can see that with
> > the fact that the list handling helpers have no memory barriers, that
> > the above two lines could be seen to execute in the reverse order, e.g.
> >
> > 	prev->next = next;
> > 	next->prev = prev;
> >
> > so another CPU could find and delete next before this one has finished
> > doing so. Would the list end up in a consistent state where no loops
> > develop and no probes are missed? I don't know the answer and a full
> > analysis would be complicated, but my gut feeling is that if a cpu can
> > observe the links in the list in an inconsistent state then only bad
> > things can result.
> 
> Just a comment, arch_optimize_kprobes() are only called under
> kprobe_mutex held. No concurrent update happens :)

Except in the case of the code I was commenting on which was using
stop_machine to make all cpu's simultaneously do the work of
arch_optimize_kprobes :-)

-- 
Tixy

