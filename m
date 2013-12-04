Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3LDKBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:01:01 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:57870 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3LDKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:00:57 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        cody@linux.vnet.ibm.com, schwidefsky@de.ibm.com, utz.bacher@de.ibm.com,
        mmarek@suse.cz, rmallon@gmail.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <201312031605.38972.arnd@arndb.de>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <20131203143010.GB3521@kroah.com>
	 <1386082011.29309.2.camel@oc7383187364.ibm.com>
	 <201312031605.38972.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 04 Dec 2013 10:59:33 +0100
Message-ID: <1386151173.7883.13.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-6892-0000-0000-00000719FB3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

thanks for helping to review the code.

Am Dienstag, den 03.12.2013, 16:05 +0100 schrieb Arnd Bergmann:
> On Tuesday 03 December 2013, Frank Haverkamp wrote:
> > Ohh, sorry __u64 of course:
> > 
> > /* common struct for chip image exchange */
> > struct genwqe_bitstream {
> >         __u64 data_addr;                /* pointer to image data */
> >         __u32 size;                     /* size of image file */
> >         __u32 crc;                      /* crc of this image */
> >         __u8  partition;                /* '0', '1', or 'v' */
> >         __u64 target_addr;              /* starting address in Flash */
> >         __u8  uid;                      /* 1=host/x=dram */
> > 
> >         __u64 slu_id;                   /* informational/sim: SluID */
> >         __u64 app_id;                   /* informational/sim: AppID */
> > 
> >         __u16 retc;                     /* returned from processing */
> >         __u16 attn;                     /* attention code from
> > processing */
> >         __u32 progress;                 /* progress code from processing
> > */
> > };
> > 
> > and than I do in my userspace application:
> > 
> >         load.data_addr = (unsigned long)buf;
> > 
> > Is that ok, or must I consider more?
> > 
> 
> I haven't followed the recent discussions, jumping into the middle here:
> The structure above is not safe for a generic ioctl interface because it
> has different padding on x86-32 and x86-64, where __u64 has different
> alignment.
> 
> You can try to avoid the implicit padding by sorting the members by size,
> by making some lignments for 32-bit and 64-bit. I avoid umembers larger or by adding explicit padding.
> 
> 	Arnd
> 

Ok, let me try to sort my entries a little differently and modify some
sizes, to avoid different alignments for 32-bit and 64-bit. I avoid
using __u8 now such that I always have nice 64-bit blocks. Would the
following version work?

struct genwqe_bitstream {
	__u64 data_addr;		/* pointer to image data */
	__u32 size;			/* size of image file */
	__u32 crc;			/* crc of this image */
	__u64 target_addr;		/* starting address in Flash */
	__u32 partition;		/* '0', '1', or 'v' */
	__u32 uid;			/* 1=host/x=dram */

	__u64 slu_id;			/* informational/sim: SluID */
	__u64 app_id;			/* informational/sim: AppID */

	__u16 retc;			/* returned from processing */
	__u16 attn;			/* attention code from processing */
	__u32 progress;			/* progress code from processing */
};

If not, I might have missed something, and I would appreciate if you
could make up an example how a good version should look like.

Thanks

Frank

