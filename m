Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaD0UB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 16:01:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbaD0UA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 16:00:56 -0400
Date: Sun, 27 Apr 2014 22:00:43 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: tiwai@suse.de, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Laurent Navet <laurent.navet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140427200042.GA23846@mguzik.redhat.com>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
 <20140426215945.GC17562@mguzik.redhat.com>
 <20140427173932.GP26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140427173932.GP26890@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 08:39:32PM +0300, Dan Carpenter wrote:
> On Sat, Apr 26, 2014 at 11:59:46PM +0200, Mateusz Guzik wrote:
> > > And sadly enough some of those ->id strings are more than 15 characters
> > > and a NUL which will fit in card->id.  So this overflow is real.  The
> > > card->shortname is a 32 char array so none of those overflow.
> > > 
> > > If we want to sovle the truncation issue then we need to think of
> > > shorter names for BassPODxtLive, BassPODxtPro, PODStudioUX1, and
> > > PODStudioUX2.
> > > 
> > 
> > In that case I suggest compile time assertions that ids and names fit
> 
> That sounds like some magic code which I would love to see.  :)
> 

Just asserting something on compile time is not a problem.

The kernel has BUILD_BUG_ON macro. I didn't check why, but it doesn't
use _Static_assert. Instead it produces some code which makes it
unusable in this context.

Aforementoined _Static_assert is available at least in gcc and clang and
you can call it outside of any function, e.g.:
_Static_assert(sizeof(meh) < 42, "oh no");

Unfortnately I failed to come up with a macro which would allow me to use
it in the initializer. :/

One could change line6_properties's definition so that it contains
arrays instead of pointers, that would introduce automagic checking and
I don't think memory waste (if any) would be problematic.

> >  and a WARN_ON + -EINVAL in line6_init_audio to catch future
> >  offenders.
> 
> Returning -EINVAL is a bad idea because it would break the driver
> completely and make it unusable.
> 

Well I would vote for returning the error anyway. Something is wrong,
better fix it as it is instead of risking additional bugs resulting
from truncation.


> > 
> > As a side note I'm not sure if pod_try_init from drivers/staging/line6/pod.c
> > cleans up properly after failed line6_init_audio.
> 
> Yeah.  It doesn't seem to clean up at all.
> 

-- 
Mateusz Guzik
