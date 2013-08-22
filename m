Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3HVEBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 00:01:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab3HVEBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 00:01:40 -0400
Date: Wed, 21 Aug 2013 21:03:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>, rusty@rustcorp.com.au,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Subject: Re: [RFC PATCH next]module: Fix mod->mkobj.kobj potentially freed
 too early
Message-ID: <20130822040333.GB4821@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421>
 <20130821161819.GA14364@kroah.com>
 <1377138846.2633.25.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377138846.2633.25.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:34:06AM +0800, Li Zhong wrote:
> On Wed, 2013-08-21 at 09:18 -0700, Greg KH wrote:
> > On Wed, Aug 21, 2013 at 05:49:58PM +0800, Li Zhong wrote:
> > > DEBUG_KOBJECT_RELEASE helps to find the issue attached below.
> > > 
> > > After some investigation, it seems the reason is:
> > > The mod->mkobj.kobj(ffffffffa01600d0 below) is freed together with mod
> > > itself in free_module(). However, its children still hold references to
> > > it, as the delay caused by DEBUG_KOBJECT_RELEASE. So when the
> > > child(holders below) tries to decrease the reference count to its parent
> > > in kobject_del(), BUG happens as it tries to access already freed memory.
> > 
> > Ah, thanks for tracking this down.  I had seen this in my local testing,
> > but wasn't able to figure out the offending code.
> > 
> > > This patch tries to fix it by waiting for the mod->mkobj.kobj to be
> > > really released in the module removing process (and some error code
> > > paths).
> > 
> > Nasty, we should just be freeing the structure in the release function,
> > why doesn't that work?
> 
> Hi Greg,
> 
> It seems I didn't describe it clearly in the previous mail. I'm trying
> to do it better below: 
> 
> mod->mkobj.kobj is embedded in module_kobject(not a pointer):
> struct module_kobject {
>         struct kobject kobj;
> 	...
> 
> and allocated with the module memory. So we could see the parent below
> ffffffffa01600d0 is between MODULES_VADDR (ffffffffa0000000) and
> MODULES_END(ffffffffff000000). 
> 
> It seem to me that the mkobj.kobj is freed by module_free(mod,
> mod->module_core). 

Ick, you are right.  If a kobject is being embedded in an object, it
should control the lifespan of the object, not somewhere else like is
happening here.

The best solution for this is to make the kobject a pointer, not
embedded in the structure, that will fix this issue, right?

thanks,

greg k-h
