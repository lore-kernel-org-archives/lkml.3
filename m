Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaIQUTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:19:09 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:50714 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbaIQUTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:19:07 -0400
Date: Wed, 17 Sep 2014 16:18:33 -0400 (EDT)
From: Rodrigo Freire <rfreire@redhat.com>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: dwmw2 <dwmw2@infradead.org>, nbd@openwrt.org, computersforpeace@gmail.com,
        linux-kernel@vger.kernel.org, herton@redhat.com,
        linux-mtd@lists.infradead.org
Message-ID: <1761405154.40124217.1410985113708.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140909170231.GA14429@logfs.org>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com> <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com> <20140909170231.GA14429@logfs.org>
Subject: Re: [PATCH] block2mtd: mtd: Present block2mtd timely on boot time
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF24 (Linux)/8.0.6_GA_5922)
Thread-Topic: block2mtd: mtd: Present block2mtd timely on boot time
Thread-Index: NA7xr3Fp8BrLBG24gfnLmgGCJ6HXGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jörn,

----- Original Message ----- 
From: "Jörn Engel" <joern@logfs.org> 
> On Mon, 8 September 2014 16:04:40 -0400, Rodrigo Freire wrote: 
> > 
> > @@ -257,13 +281,15 @@ static struct block2mtd_dev *add_device( 
> > 
> > /* Setup the MTD structure */ 
> > /* make the name contain the block device in */ 
> > - name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname); 
> > + if (!mtdname) 
> > + mtdname = devname; 
> > + name = kmalloc(strlen(mtdname) + 1, GFP_KERNEL); 
> > if (!name) 
> > goto err_destroy_mutex; 
> > 
> > + strcpy(name, mtdname); 
> kstrdup. 
> And see below for the ABI change. 

Thanks for pointing. Fixed.


> >  	dev->mtd.name = name;
> > -
> > -	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
> > +	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK & ~(erase_size - 1);
> 
> PAGE_MASK is no longer needed with the new term.  Or does anyone
> seriously want to support erase_size < PAGE_SIZE?

Makes sense. I was talking to Felix and indeed there are some MTD devices 
which have 4k erase page size. Unheard of something smaller.
But it is on the MTD land and not block2mtd.


> Timeout has a default value, but name defaults to NULL. Add three 
> devices without specifying the name and you get funny results. 
> If we handled the NULL case by doing what the driver used to do before 
> this patch, I think this would be fine. 

Please see the fragment below:

@@ -257,13 +281,15 @@ static struct block2mtd_dev *add_device(
 
 	/* Setup the MTD structure */
 	/* make the name contain the block device in */
-	name = kasprintf(GFP_KERNEL, "block2mtd: %s", devname);
+	if (!mtdname)
+		mtdname = devname;
+	name = kstrdup(mtdname, GFP_KERNEL);
 	if (!name)
 		goto err_destroy_mutex;

If the name is a NULL or not provided, the mtdname will then become the mtd device name.
I also tried mounting several partitions, with both specified name and not and everything seemed to work nicely.

See a V2 patch on the next message.
