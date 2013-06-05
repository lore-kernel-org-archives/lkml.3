Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3FERKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:10:19 -0400
Received: from longford.logfs.org ([213.229.74.203]:59397 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3FERKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:10:17 -0400
Date: Wed, 5 Jun 2013 11:41:07 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
Message-ID: <20130605154106.GA2737@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51AF646D.7030903@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 June 2013 00:16:45 +0800, vaughan wrote:
> 于 2013年06月05日 21:27, Jörn Engel 写道:
> >On Wed, 5 June 2013 17:18:33 +0800, vaughan wrote:
> >>
> >>Check and set sdp->exclude should be atomic when set in sg_open().
> >
> >The patch is line-wrapped.  More importantly, it doesn't seem to do
> It's shorter than the original line, so I just leave it like this...

Sure.  What I meant by line-wrapped is that your mailer mangled the
patch.  Those two lines should have been one:
> >>-                       ((!sfds_list_empty(sdp) || get_exclude(sdp))
> >>? 0 : set_exclude(sdp, 1)));

> >what your description indicates it should do.  And lastly, does this
> >fix a bug, possibly even one you have a testcase for, or was it found
> >by code inspection?
> I found it by code inspection. A race condition may happen with the
> old code if two threads are both trying to open the same sg with
> O_EXCL simultaneously. It's possible that they both find fsds list
> is empty and get_exclude(sdp) returns 0, then they both call
> set_exclude() and break out from wait_event_interruptible and resume
> open. So it's necessary to check again with sg_open_exclusive_lock
> held to ensure only one can set sdp->exclude and return >0 to break
> out from wait_event loop.

Makes sense.  And reading the code again, I have to wonder what monkey
came up with the get_exclude/set_exclude functions.

Can I sucker you into a slightly larger cleanup?  I think the entire
"get_exclude(sdp)) ? 0 : set_exclude(sdp, 1)" should be simplified.
And once you add the try_set_exclude(), set_exclude will only ever do
clear_exclude, so you might as well rename and simplify that as well.

Let no good deed go unpunished.

Jörn

--
It's just what we asked for, but not what we want!
-- anonymous
