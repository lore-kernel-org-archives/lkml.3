Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3FFQLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:11:42 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47555 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab3FFQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:35 -0400
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: =?UTF-8?q?=5BPATCH=200/6=5D=20keucr=3A=20checkpatch=20fixes?=
Date: Thu,  6 Jun 2013 18:10:44 +0200
Message-Id: <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130605094517.GS28112@mwanda>
References: <20130605094517.GS28112@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

did some improvement on our previous patch series, see the more detailed
replies below.


[PATCH 1/6] keucr: remove some unneccesary typedefs

On Wed, Jun 05, 2013 at 12:25:02PM +0300, Dan Carpenter wrote:
> On Wed, Jun 05, 2013 at 10:50:01AM +0200, Johannes Schilling wrote:
> > resolves checkpatch.pl warning "do not add new typedefs"
>·
> If you're going to do this, then you may as well give the struct a
> better name at the same time.

did that.



[PATCH 2/6] keucr: use more specific max_t(int, ..

On Wed, Jun 05, 2013 at 12:45:17PM +0300, Dan Carpenter wrote:
> On Wed, Jun 05, 2013 at 10:50:06AM +0200, Johannes Schilling wrote:
> > --- a/drivers/staging/keucr/transport.c
> > +++ b/drivers/staging/keucr/transport.c
> > @@ -708,8 +708,8 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
> >··
> >  »  »   } else {
> >  »  »   »   residue = min(residue, transfer_length);
> > -»  »   »   scsi_set_resid(srb, max(scsi_get_resid(srb),
> > -»  »   »   »   »   »   »   (int) residue));
> > +»  »   »   scsi_set_resid(srb, max_t(int, scsi_get_resid(srb),
> > +»  »   »   »   »   »   »   (int)residue));
>                                                         ^^^^^
> This cast isn't needed any more when you use max_t.

right. i removed it.



[PATCH 3/6] keucr: migrate printk to dev_dbg/info/warn/err

On Wed, Jun 05, 2013 at 02:32:07AM -0700, Dan Carpenter wrote:
> On Wed, Jun 05, 2013 at 10:50:03AM +0200, Johannes Schilling wrote:
> > diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
> > index a0fdffd..0e8ced1 100644
> > --- a/drivers/staging/keucr/init.c
> > +++ b/drivers/staging/keucr/init.c
> > @@ -19,13 +19,13 @@ int ENE_InitMedia(struct us_data *us)
> >  »  int»result;
> >  »  BYTE»   MiscReg03 = 0;
> >··
> > -»  printk(KERN_INFO "--- Init Media ---\n");
> > +»  dev_info("--- Init Media ---\n");
>·
> Come on people, what's going on here?  This won't compile at all. :/

sorry about that one. fixed, to compile now.
all printks in drivers/staging/keucr/ are now dev_<facility> calls.



[PATCH 4/6] keucr: more readable and friendly error messages

we replaced all error messages that had !! or similar in them with more
neutral ones. also expanded some abbreviations for read/understandability.



[PATCH 5/6] keucr: moved function to other file

migrating printk to dev_<facility> stuff revealed that usb_stor_print_cmd is
(like a lot of functions in this module) declared in init.c, but this one is
only used in transport.c, so we moved it there and made it static.



[PATCH 6/6] keucr: fix some alignment- and whitespace-problems

general alignment and whitespace-fixes, also fix stuff that appears in other
commits but isn't fixed there because they don't deal with
alignment/whitespace.



this all applies cleanly against next-20130605, if necessary i can rediff
against later ones.

regards,
   laura lawniczak, johannes schilling


total diffstat:

Johannes Schilling (3):
  keucr: remove some unneccesary typedefs
  keucr: use more specific max_t(int, ..
  keucr: fix some alignment- and whitespace-problems

Laura Lawniczak (3):
  keucr: migrate printk to dev_dbg/info/warn/err
  keucr: more readable and friendly error messages
  keucr: moved function to other file

 drivers/staging/keucr/init.c      |  102 ++++++++-----------------------
 drivers/staging/keucr/scsiglue.c  |    7 ++-
 drivers/staging/keucr/smil.h      |   28 ++-------
 drivers/staging/keucr/smilmain.c  |  122 ++++++++++++++++++-------------------
 drivers/staging/keucr/smilsub.c   |   27 +++++---
 drivers/staging/keucr/smscsi.c    |    6 +-
 drivers/staging/keucr/transport.c |   58 ++++++++++++++++--
 drivers/staging/keucr/transport.h |    1 -
 drivers/staging/keucr/usb.c       |    8 +--
 drivers/staging/keucr/usb.h       |   30 ++++-----
 10 files changed, 188 insertions(+), 201 deletions(-)

-- 
1.7.10.4

