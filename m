Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaGPVA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:00:28 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:56700 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaGPVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:00:26 -0400
Date: Wed, 16 Jul 2014 23:00:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: Add support for seek and shorter read to
 /dev/mdesc
Message-ID: <20140716210019.GA6587@ravnborg.org>
References: <1405519323-3092-1-git-send-email-khalid.aziz@oracle.com>
 <20140716190414.GA6028@ravnborg.org>
 <53C6E214.3030902@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C6E214.3030902@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 02:35:32PM -0600, Khalid Aziz wrote:
> Hi Sam,
> 
> Thanks for the feedback.
> 
> On 07/16/2014 01:04 PM, Sam Ravnborg wrote:
> >Hi Kahlid.
> >
> >On Wed, Jul 16, 2014 at 08:02:03AM -0600, Khalid Aziz wrote:
> >>/dev/mdesc on Linux does not support reading arbitrary number
> >>of bytes and seeking while /dev/mdesc on Solaris does. This
> >>causes tools that work on Solaris to break on Linux. This patch
> >>adds these two capabilities to /dev/mdesc.
> >>
> >>Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
> >>---
> >>  arch/sparc/kernel/mdesc.c | 77 ++++++++++++++++++++++++++++++++++++++++-------
> >>  1 file changed, 66 insertions(+), 11 deletions(-)
> >>
> >>+/* mdesc_open() - Grab a reference to mdesc_handle when /dev/mdesc is
> >>+ *	opened. Hold this reference until /dev/mdesc is closed to ensure
> >>+ *	mdesc data structure is not released underneath us. Store the
> >>+ *	pointer to mdesc structure in private_data for read and seek to use
> >>+ */
> >>+static int mdesc_open(struct inode *inode, struct file *file)
> >>  {
> >>  	struct mdesc_handle *hp = mdesc_grab();
> >>
> >>  	if (!hp)
> >>  		return -ENODEV;
> >>
> >>+	file->private_data = hp;
> >>+	return 0;
> >>+}
> >
> >Do we know the open/close always come in pairs?
> >I assume so - but there is no check fo this (at least on this level).
> 
> Most likely yes, but I wouldn't assume that to be guaranteed. Is that a
> concern? Isn't "struct file" unique for each instance of open?
I did not know. But I have checked a few other users
of file_operations and they do not provide any protections.
So you implementation is OK.


> >>+
> >>+static ssize_t mdesc_read(struct file *file, char __user *buf,
> >>+			  size_t len, loff_t *offp)
> >>+{
> >>+	struct mdesc_handle *hp = file->private_data;
> >>+	unsigned char *mdesc;
> >>+	int err, bytes_left;
> >>+
> >>+	if (*offp >= hp->handle_size)
> >>+		return 0;
> >>+	err = len;
> >>+	bytes_left = hp->handle_size - *offp;
> >>+	if (len > bytes_left)
> >>+		err = bytes_left;
> >>+	mdesc = (unsigned char *)&hp->mdesc;
> >>+	mdesc += *offp;
> >>+	if (copy_to_user(buf, mdesc, err))
> >>  		err = -EFAULT;
> >>-	mdesc_release(hp);
> >>+	else
> >>+		*offp += err;
> >>+
> >>+	return err;
> >>+}
> >
> >When reading your code it is confusing to read that err is set to len,
> >and then maybe later set to an error value or a new len.
> >
> >See the following refactoring of mdesc_read() that avoids the err local
> >variable resulting in more readable code.
> >
> >static ssize_t mdesc_read(struct file *file, char __user *buf,
> >                        size_t len, loff_t *offp)
> >{
> >      struct mdesc_handle *hp = file->private_data;
> >      unsigned char *mdesc;
> >      int bytes_left;
> >
> >      if (*offp >= hp->handle_size)
> >              return 0;
> >
> >      bytes_left = hp->handle_size - *offp;
> >      if (len > bytes_left)
> >              len = bytes_left;
> >
> >      mdesc = (unsigned char *)&hp->mdesc;
> >      mdesc += *offp;
> >      if (!copy_to_user(buf, mdesc, len)) {
> >              *offp += len;
> >	     return len;
> >      } else {
> >              return -EFAULT;
> >      }
> >}
> >
> >The above is IMO more readable.
> 
> I was simply following how err was used in the original code, but I agree
> this is more readable. I can redo the patch.
Please do so.

	Sam
