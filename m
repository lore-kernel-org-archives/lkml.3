Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3HVHLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:11:19 -0400
Received: from ozlabs.org ([203.10.76.45]:37900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab3HVHLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:11:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>, Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Subject: Re: [RFC PATCH next]module: Fix mod->mkobj.kobj potentially freed too early
In-Reply-To: <20130821161819.GA14364@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421> <20130821161819.GA14364@kroah.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 22 Aug 2013 16:30:53 +0930
Message-ID: <87vc2yciqi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Wed, Aug 21, 2013 at 05:49:58PM +0800, Li Zhong wrote:
> >  struct kobj_type module_ktype = {
> > +	.release   =	module_kobj_release,
> >  	.sysfs_ops =	&module_sysfs_ops,
> >  };
>
> Wait, as there is no release function here for the kobject (a different
> problem), why is the deferred release function causing any problems?
> There is no release function to call, so what is causing the oops?

Because DEBUG_KOBJECT_RELEASE does the kobject_put() sometime later,
which is what causes the oops.

Since kobjects don't have an owner field, AFAICT someone *could* grab
one in a module which is unloading, then put it after unload.   So this
fixes a real bug, albeit not one seen in the real world.

Applied,
Rusty.
