Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaDCTt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 15:49:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbaDCTt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 15:49:27 -0400
Date: Thu, 3 Apr 2014 21:49:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes/x86: Introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140403194927.GA12639@redhat.com>
References: <20140331194415.GA9307@redhat.com> <1396467984.4659.53.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396467984.4659.53.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Jim Keniston wrote:
>
> On Mon, 2014-03-31 at 21:44 +0200, Oleg Nesterov wrote:
> ...
> > +/*
> > + * Adjust the return address pushed by a call insn executed out of line.
> > + */
> > +static int adjust_ret_addr(unsigned long sp, long correction)
> > +{
> > +	int rasize, ncopied;
> > +	long ra = 0;
> > +
> > +	if (is_ia32_task())
> > +		rasize = 4;
> > +	else
> > +		rasize = 8;
> > +
> > +	ncopied = copy_from_user(&ra, (void __user *)sp, rasize);
> > +	if (unlikely(ncopied))
> > +		return -EFAULT;
> > +
> > +	ra += correction;
> > +	ncopied = copy_to_user((void __user *)sp, &ra, rasize);
> > +	if (unlikely(ncopied))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
>
> This isn't your bug, Oleg -- you're just moving code -- but consider
> taking this opportunity to fix it...
>
> "ncopied" is a misnomer here.  copy_from_user() and copy_to_user()
> return the number of bytes that could NOT be copied.

Yes, thanks. I'll try to cleanup this later. I am not sure yet, but
perhaps I will change adjust_ret_addr() and hijack_return_addr() to
use a couple of new get/put_user helpers, because ->call_emulate()
needs to check is_ia32_task() and write to *sp too.

Thanks.

Oleg.

