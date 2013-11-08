Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3KHUHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:07:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab3KHUHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:07:07 -0500
Date: Fri, 8 Nov 2013 15:06:59 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: hsweeten@visionengravers.com
Subject: Re: staging: comedi: drivers: use comedi_dio_update_state() for
 complex cases
Message-ID: <20131108200659.GA2101@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	hsweeten@visionengravers.com
References: <20131107062754.93B2D660F4A@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107062754.93B2D660F4A@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 06:27:54AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=b3ff824a81e8978deb56f6d163479c1a0a606037
 > Commit:     b3ff824a81e8978deb56f6d163479c1a0a606037
 > Parent:     97f4289ad08cffe55de06d4ac4f89ac540450aee
 > Author:     H Hartley Sweeten <hsweeten@visionengravers.com>
 > AuthorDate: Fri Aug 30 11:06:17 2013 -0700
 > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > CommitDate: Tue Sep 17 07:47:40 2013 -0700
 > 
 >     staging: comedi: drivers: use comedi_dio_update_state() for complex cases
 >     
 >     Use comedi_dio_update_state() to handle the boilerplate code to update
 >     the subdevice s->state for more complex cases where the hardware is only
 >     updated based on the 'mask' of the channels that are modified.
 >     
 >     Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
 >     Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
 >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 
This bit looks suspect :-
 
 >  	if (mask) {
 > -		s->state &= ~mask;
 > -		s->state |= (bits & mask);
 > -
 >  		if (mask & 0x00ff)
 >  			outb(s->state & 0xff, dev->iobase + reg);
 > -		if ((mask & 0xff00) && (s->n_chan > 8))
 > +		if ((mask & 0xff00) & (s->n_chan > 8))
 >  			outb((s->state >> 8) & 0xff, dev->iobase + reg + 1);
 > -		if ((mask & 0xff0000) && (s->n_chan > 16))
 > +		if ((mask & 0xff0000) & (s->n_chan > 16))
 >  			outb((s->state >> 16) & 0xff, dev->iobase + reg + 2);
 > -		if ((mask & 0xff000000) && (s->n_chan > 24))
 > +		if ((mask & 0xff000000) & (s->n_chan > 24))
 >  			outb((s->state >> 24) & 0xff, dev->iobase + reg + 3);
 >  	}


should those be shifts ? Like so ?


diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index d041b714db29..29a54e5d73d6 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -173,11 +173,11 @@ static int pcl730_do_insn_bits(struct comedi_device *dev,
 	if (mask) {
 		if (mask & 0x00ff)
 			outb(s->state & 0xff, dev->iobase + reg);
-		if ((mask & 0xff00) & (s->n_chan > 8))
+		if ((mask & 0xff00) & (s->n_chan >> 8))
 			outb((s->state >> 8) & 0xff, dev->iobase + reg + 1);
-		if ((mask & 0xff0000) & (s->n_chan > 16))
+		if ((mask & 0xff0000) & (s->n_chan >> 16))
 			outb((s->state >> 16) & 0xff, dev->iobase + reg + 2);
-		if ((mask & 0xff000000) & (s->n_chan > 24))
+		if ((mask & 0xff000000) & (s->n_chan >> 24))
 			outb((s->state >> 24) & 0xff, dev->iobase + reg + 3);
 	}
 
