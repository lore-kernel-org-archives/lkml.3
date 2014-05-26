Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaEZLO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:14:58 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8965 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaEZLO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:14:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 May 2014 04:08:15 -0700
Date: Mon, 26 May 2014 14:14:53 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Saravana Kannan <skannan@codeaurora.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Mike Turquette" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] clk: flatten clk tree in debugfs
Message-ID: <20140526111453.GE5961@tbergstrom-lnx.Nvidia.com>
References: <1400842772-4862-1-git-send-email-pdeschrijver@nvidia.com>
 <537FCAA0.6080106@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <537FCAA0.6080106@codeaurora.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:24:32AM +0200, Saravana Kannan wrote:
> On 05/23/2014 03:59 AM, Peter De Schrijver wrote:
> > This patch flattens the clk tree in CCF debugfs. Instead of representing the
> > clocks and their hierarchy as a directory structure under
> > /sys/kernel/debug/clk, each clock gets a single directory directly under
> > /sys/kernel/debug/clk.
> >
> > While this may seem strange, here's way I think this is the right thing to do:
> >
> > 1) a directory structure cannot be 'snapshotted' atomically, therefore it's
> >     not in general possible to get a consistent view of the clocktree, because
> >     clocks can be reparented at any time. This was solved by adding clk_dump
> >     and clk_summary, which do guarantee an atomic snapshot of the tree.
> >     Therefore I think the directory structure doesn't add any value.
> >
> > 2) When writing userspace programs which use the files in the clock
> >     directories (eg. for testing purposes), it's impossible to know for sure
> >     where a certain clock will be, because it might have been reparented by the
> >     time you figured out the path from clk_dump. This makes writing such
> >     programs more difficult than it should be.
> >
> > So because the directory structure doesn't give any information we don't
> > already provide by other means and it makes certain usecases more difficult
> > than the should be, I think we should move to a flat directory containing
> > one subdir per clock.
> 
> Completely agree and a huge ACK to this idea.
> 

Thanks.

> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >   drivers/clk/clk.c |   54 +++-------------------------------------------------
> >   1 files changed, 4 insertions(+), 50 deletions(-)
> >
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index dff0373..53c6b4f 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -306,7 +306,7 @@ static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
> >   		goto out;
> >
> >   	hlist_for_each_entry(child, &clk->children, child_node)
> > -		clk_debug_create_subtree(child, clk->dentry);
> > +		clk_debug_create_subtree(child, pdentry);
> >
> >   	ret = 0;
> >   out:
> > @@ -326,29 +326,20 @@ out:
> >    */
> >   static int clk_debug_register(struct clk *clk)
> >   {
> > -	struct clk *parent;
> >   	struct dentry *pdentry;
> >   	int ret = 0;
> >
> >   	if (!inited)
> >   		goto out;
> >
> > -	parent = clk->parent;
> > -
> >   	/*
> >   	 * Check to see if a clk is a root clk.  Also check that it is
> >   	 * safe to add this clk to debugfs
> >   	 */
> > -	if (!parent)
> > -		if (clk->flags & CLK_IS_ROOT)
> > -			pdentry = rootdir;
> > -		else
> > -			pdentry = orphandir;
> > +	if (clk->flags & CLK_IS_ROOT)
> > +		pdentry = rootdir;
> >   	else
> > -		if (parent->dentry)
> > -			pdentry = parent->dentry;
> > -		else
> > -			goto out;
> > +		pdentry = orphandir;
> 
> I'm confused by this code. Shouldn't pdentry always be the same? Do we 
> need a dir for orphans? Also, I'm not sure the code is actually right? 

Indeed. This code is most likely wrong... I don't have a strong opinion
if we need an orphan dir or if we can just have a file to list orphaned
clocks. I would still like to be able to see if there are orphaned clocks.
You could argue that the same race exists for the orphan dir. It is possible
for the parent to be registered while you're traversing the orphan dir and
cause a clock to move around. In practice this seems rather unlikely to happen
to me?

> Looks like you are putting everything but the root into orphandir?
> 

Yes...

Cheers,

Peter.
