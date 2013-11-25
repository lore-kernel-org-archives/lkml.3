Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3KYKFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:05:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:44193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab3KYKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:05:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,766,1378882800"; 
   d="scan'208";a="414142396"
Date: Mon, 25 Nov 2013 12:11:54 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] sysfs: handle duplicate removal attempts in
 sysfs_remove_group()
Message-ID: <20131125101154.GS2281@intel.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com>
 <20131123230701.GA6183@kroah.com>
 <2196420.QNWb3mfseF@vostro.rjw.lan>
 <3805095.rqdZNnA0Ng@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3805095.rqdZNnA0Ng@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 02:09:09AM +0100, Rafael J. Wysocki wrote:
> On Sunday, November 24, 2013 12:36:03 AM Rafael J. Wysocki wrote:
> > On Saturday, November 23, 2013 03:07:01 PM Greg Kroah-Hartman wrote:
> > > On Sun, Nov 24, 2013 at 12:12:59AM +0100, Rafael J. Wysocki wrote:
> > > > On Saturday, November 23, 2013 02:53:58 PM Greg Kroah-Hartman wrote:
> 
> [...]
> 
> > > > > 
> > > > > I can revert Mika's patch, as it would be good to catch these kinds of
> > > > > errors.
> > > > 
> > > > Then we'll need to untangle the SATA/SCSI mess triggered by Bjorn in
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=65281. ;-)
> > > 
> > > I have no objection to fixing that, the scsi sysfs handling is "odd" to
> > > say the least...
> > > 
> > > If someone can unwind it, that would be great to see happen...
> > 
> > Well, if I'm bored to death during the xmas holidays, I may look into that.
> 
> In fact, I'm not exactly sure why ata_port_detach() calls ata_tport_delete()
> before scsi_remove_host()?  Is there any particular reason?  Because that
> doesn't seem to be exactly right ...

I tried so that I have your 'PCI: Move device_del() from pci_stop_dev() to
pci_destroy_dev()' applied and then I did following change as you
suggested.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 81a94a3919db..07a03f93d640 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6304,10 +6304,10 @@ static void ata_port_detach(struct ata_port *ap)
 		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
 			ata_tlink_delete(&ap->pmp_link[i]);
 	}
-	ata_tport_delete(ap);
-
 	/* remove the associated SCSI host */
 	scsi_remove_host(ap->scsi_host);
+
+	ata_tport_delete(ap);
 }
 
 /**

After both patches are applied the warnings are gone :) However, looks like
both are needed since if I only apply one or another, I still get warnings.
