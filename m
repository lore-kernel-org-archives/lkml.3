Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3EPM14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:27:56 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11159 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441Ab3EPM1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:27:55 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Thu, 16 May 2013 14:27:52 +0200
To: Dave Chinner <dchinner@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mm: vmscan: handle any negative return value from
 scan_objects
Message-ID: <20130516122752.GG24072@caracas.corpusers.net>
References: <1368693736-15486-1-git-send-email-oskar.andero@sonymobile.com>
 <20130516115212.GC11167@devil.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130516115212.GC11167@devil.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:52 Thu 16 May     , Dave Chinner wrote:
> On Thu, May 16, 2013 at 10:42:16AM +0200, Oskar Andero wrote:
> > The shrinkers must return -1 to indicate that it is busy. Instead, treat
> > any negative value as busy.
> 
> Why? The API defines return condition for aborting a scan and gives
> a specific value for doing that. i.e. explain why should change the
> API to over-specify the 'abort scan" return value like this.

As I pointed out earlier, looking in to the code (from master):
	if (shrink_ret == -1)
		break;
	if (shrink_ret < nr_before)
		ret += nr_before - shrink_ret;

This piece of code lacks a sanity check and will only function if shrink_ret
is either greater than zero or exactly -1. If shrink_ret is e.g. -2 this will
lead to undefined behaviour.

> FWIW, using "any" negative number for "abort scan" is a bad API
> design decision. It means that in future we can't introduce
> different negative return values in the API if we have a new to.
> i.e. each specific negative return value needs to have the potential
> for defining a different behaviour. 

An alternative to my patch would be to add:
if (shrink_ret < -1)
   /* handle illegal return code in some way */

> So if any change needs to be made, it is to change the -1 return
> value to an enum and have the shrinkers return that enum when they
> want an abort.

I am all for an enum, but I still believe we should handle the case where
the shrinkers return something wicked.

-Oskar
