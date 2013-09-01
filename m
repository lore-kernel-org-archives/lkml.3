Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab3IBAMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:12:23 -0400
Received: from ozlabs.org ([203.10.76.45]:56194 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab3IBAMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:12:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rmk+kernel@arm.linux.org.uk
Subject: Re: [RFC PATCH v2 next]module: Fix mod->mkobj.kobj potentially freed too early
In-Reply-To: <20130827062135.GA3395@kroah.com>
References: <1377078598.2709.25.camel@ThinkPad-T5421> <20130821161819.GA14364@kroah.com> <1377138846.2633.25.camel@ThinkPad-T5421> <20130822040333.GB4821@kroah.com> <1377157075.2633.63.camel@ThinkPad-T5421> <20130825040734.GA18107@kroah.com> <87bo4jd9z0.fsf@rustcorp.com.au> <20130827062135.GA3395@kroah.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 02 Sep 2013 09:21:55 +0930
Message-ID: <871u58ayn8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Tue, Aug 27, 2013 at 02:08:27PM +0930, Rusty Russell wrote:
>> Greg KH <gregkh@linuxfoundation.org> writes:
>> > On Thu, Aug 22, 2013 at 03:37:55PM +0800, Li Zhong wrote:
>> >> DEBUG_KOBJECT_RELEASE helps to find the issue attached below.
>> > People are starting to hit these types of issues, and I'd like to take
>> > this one out of the picture.
>> >
>> > Rusty, any objection to me taking this through my driver-core tree,
>> > where this new config option shows up?
>> 
>> The original fix was better.
>> 
>> Moving the module_kobject out and giving it its own lifetime solves this
>> immediate issue, but it still means there's an accessible module_kobject
>> around referring to a module which doesn't exist any more.
>
> That's ok, it could happen before as well.  What's wrong with that?
>
>> Original copied below, feel free to take it.
>
> You are just sitting and sleeping until someone drops the last reference
> to the module.  What if userspace grabs a reference from sysfs?  That
> could never return, I don't think you want to stall that out.

In your scenario, what happens if userspace grabs a reference via sysfs?
It then tries to use module_kobj->mod which points into freed memory?

eg. show_modinfo_##field or show_refcnt.

Is there an owner field I'm missing somewhere which stops this from
happening?  Otherwise, we can't unload the module until it's done.

> I'd prefer not having 2 things determining the lifecycle of a single
> object, that's messy, and not needed at all.

Normally you'd grab a reference to the module via an owner pointer.
Doing that in kobject seems like overkill, so we're working around it
here...

Hope that clarifies,
Rusty.
