Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaBDICI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:02:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaBDIB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:01:58 -0500
Date: Tue, 4 Feb 2014 09:01:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: protect pinctrl_list add
Message-ID: <20140204080105.GA1428@redhat.com>
References: <20140203113900.GD1725@redhat.com>
 <52F00653.40802@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F00653.40802@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:12:51PM -0700, Stephen Warren wrote:
> On 02/03/2014 04:39 AM, Stanislaw Gruszka wrote:
> > We have few fedora bug reports about list corruption on pinctrl,
> > for example:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1051918
> > 
> > Most likely corruption happen due lack of protection of pinctrl_list
> > when adding new nodes to it. Patch corrects that.
> > 
> > Fixes: 57b676f9c1b ("pinctrl: fix and simplify locking")
> 
> After that patch ...
> 
> > diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> 
> > @@ -851,7 +851,9 @@ static struct pinctrl *create_pinctrl(struct device *dev)
> >  	kref_init(&p->users);
> >  
> >  	/* Add the pinctrl handle to the global list */
> > +	mutex_lock(&pinctrl_list_mutex);
> 
> That variable doesn't exist; it got replaced with the "global"
> pinctrl_mutex. Also, since that patch, IIRC some other changes have been
> made to the locking structure, so this patch might need adjustments not
> to conflict with those changes?

I missed that, I just quicky looked at git blame. This mutex was added
again by commit 42fed7ba44e4e8c1fb27b28ad14490cb1daff3c7
"pinctrl: move subsystem mutex to pinctrl_dev struct"
and actually this is the commit that introduce the bug. Before it,
list_add_tail() was called inside pinctrl_get_locked() and was
protected by global pinctrl_mutex.

I'll post patch with fixed "Fixes:" shortly.

Thanks
Stanislaw

