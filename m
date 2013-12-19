Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3LSAFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:05:44 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55942 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3LSAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:05:42 -0500
Date: Wed, 18 Dec 2013 16:05:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Message-ID: <20131219000537.GA838@core.coreip.homeip.net>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
 <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
 <20131218234009.GA9360@yabbi.redhat.com>
 <1950536.BXYYX85NB4@dtor-d630.eng.vmware.com>
 <20131218235504.GA17958@yabbi.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218235504.GA17958@yabbi.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 09:55:04AM +1000, Peter Hutterer wrote:
> On Wed, Dec 18, 2013 at 03:48:37PM -0800, Dmitry Torokhov wrote:
> > On Thursday, December 19, 2013 09:40:09 AM Peter Hutterer wrote:
> > > > +     memset(&abs, 0, sizeof(abs));
> > > > +     for (i = valid_cnt; i < cnt; ++i)
> > > > +             if (copy_to_user(&pinfo->info[i], &abs, sizeof(abs)))
> > > > +                     return -EFAULT;
> > > > +
> > > > +     return 0;
> > > 
> > > why don't you return the number of valid copied axes to the user?
> > > that seems better even than forcing the remainder to 0.
> > 
> > Well, if your program messed up buffers that it faulted we do not know
> > for sure if data that did not cause fault ended up where it should have
> > or if it smashed something else. This condition I think should be
> > signaled early.
> 
> not 100% sure I understand but I wasn't proposing to remove the -EFAULT, i
> was proposing to replace "return 0" with "return valid_cnt".

I understand what you were saying. Now consider: your program supplied
buffer that is actually smaller than what it said to the kernel.
Depending on the exact placement we may or may not fault when we get
pass the buffer boundary, most likely not. We are likely to fault when
we go way past the buffer boundary and wracked process' memory. If we
return -EFAULT the program will at least notice that something wrong. If
we return count it will try to resubmit the remainder of operation and
not even know that there was something very bad happening.

IOW we should not treat fault condition as other partial read/write
conditions.

Thanks.

-- 
Dmitry
