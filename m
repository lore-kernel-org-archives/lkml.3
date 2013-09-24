Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3IXULs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:11:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48407 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3IXULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:11:47 -0400
Date: Tue, 24 Sep 2013 16:11:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: hpa@linux.intel.com, Steven Rostedt <rostedt@goodmis.org>,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        Stefano.Stabellini@eu.citrix.com
Subject: Re: [PATCH] xen: Do not enable spinlocks before jump_label_init()
 has executed
Message-ID: <20130924201133.GB14935@phenom.dumpdata.com>
References: <1379039384-1568-1-git-send-email-boris.ostrovsky@oracle.com>
 <20130912224719.5a4a81da@gandalf.local.home>
 <5241ED15.7090003@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241ED15.7090003@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 12:50:45PM -0700, Boris Ostrovsky wrote:
> On 09/12/2013 10:47 PM, Steven Rostedt wrote:
> >On Thu, 12 Sep 2013 22:29:44 -0400
> >Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:
> >
> >>From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>
> >>xen_init_spinlocks() currently calls static_key_slow_inc() before
> >>jump_label_init() is invoked. When CONFIG_JUMP_LABEL is set (which usually is
> >>the case) the effect of this static_key_slow_inc() is deferred until after
> >>jump_label_init(). This is different from when CONFIG_JUMP_LABEL is not set, in
> >>which case the key is set immediately. Thus, depending on the value of config
> >>option, we may observe different behavior.
> >>
> >>In addition, when we come to __jump_label_transform() from jump_label_init(),
> >>the key (paravirt_ticketlocks_enabled) is already enabled. On processors where
> >>ideal_nop is not the same as default_nop this will cause a BUG() since it is
> >>expected that before a key is enabled the latter is replaced by the former
> >>during initialization.
> >>
> >>To address this problem we need to move
> >>static_key_slow_inc(&paravirt_ticketlocks_enabled) so that it is called
> >>after jump_label_init(). We also need to make sure that this is done before
> >>other cpus start to boot. early_initcall appears to be  a good place to do so.
> >>(Note that we cannot move whole xen_init_spinlocks() there since pv_lock_ops
> >>need to be set before alternative_instructions() runs.)
> >>
> >Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> >
> >Peter,
> >
> >This fixes a regression in 3.12 against xen. Please pull and push to
> >Linus sometime soon.
> 
> Peter,
> 
> Are you planning on taking this patch?

If he hasn't done yet (and I don't see a tip-bot email so I think the answer
is no) I can do it (as I am back from my mini vacation).

Thanks for the ping!
