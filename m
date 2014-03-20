Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbaCTVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:06:52 -0400
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:59354 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759424AbaCTVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:06:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:7652:7903:8660:8957:10010:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13148:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: ship94_589fcd1dea15e
X-Filterd-Recvd-Size: 3283
Message-ID: <1395349607.7776.51.camel@joe-AO722>
Subject: Re: Cryogenic: Enabling Power-Aware Applications on Linux
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alejandra Morales <alejandra.morales@tum.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian@grothoff.org" <christian@grothoff.org>
Date: Thu, 20 Mar 2014 14:06:47 -0700
In-Reply-To: <532B5017.2070400@zytor.com>
References: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de>
	 <532B5017.2070400@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 13:31 -0700, H. Peter Anvin wrote:
> On 03/19/2014 08:55 AM, Alejandra Morales wrote:
> > 1) Open the character device corresponding to the active interface that is sending
> > the packets, which we need to know beforehand.
> > 2) Within the main loop, and before the transmission, calculate the delay and the
> > timeout and pass it to Cryogenic by calling ioctl.
> > 3) Call select before the transmission. The call to select will block until one of the
> > events that are meant to allow the resumption of the task happen: an I/O operation
> > requested by other applications or the expiration of the timeout that we set previously.
> > 4) After the loop, close the file descriptor.
> > 
> > The resulting code looks like this:
> > 
> >  1 main()
> >  2 {
> >  3     sock_fd = create_socket();
> >  4     fd = open("/dev/cryogenic/wlan0");
> >  5     while() {
> >  6         times = calculate_delay_timeout(period);
> >  7         ioctl(fd, times);
> >  8         select(fd);
> >  9         send(sock_fd);
> > 10     }
> > 11     close(fd);
> > 12     close(sock_fd);
> > 13 }
> > 
> > The call to sleep() has been removed since it is assumed now that the delay and the
> > timeout completely determine the transmission time. Nevertheless, this is just an
> > example and programmers may still want to keep it depending on the behavior
> > they want to achieve.
> 
> This looks quite interesting, but the API seems clumsy as hell.  It
> would probably make more sense to simply make the timeout an fcntl() per
> file descriptor.
> 
> > I would like to submit the module as a patch now, do you have any suggestions to
> > do this properly? Also, I would really appreciate any feedback about the code, which
> > you can find at the end of the e-mail. Thank you.
> 
> Please see Documentation/SubmittingPatches first.  Since this is a very
> ambitious piece of work, expect to get some pushback.  This is NOT a
> negative, but rather an indication that the work is valuable enough to
> work with to integrate it into the kernel.  Most likely, in my opinion,
> making this a standalone driver just isn't going to fly, but rather we
> will want to integrate it into the core I/O model.

Perhaps a similar thing be done by exposing a
user-space aggregating sleep like [u]sleep_range.


