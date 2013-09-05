Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375Ab3IEH0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:26:39 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:51993 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3IEH0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:26:37 -0400
Message-ID: <1378365995.4058.18.camel@linux-fkkt.site>
Subject: Re: [PATCH 4/5] uas: add dead request list
From: Oliver Neukum <oliver@neukum.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>,
        "open list:USB MASS STORAGE..." 
	<usb-storage@lists.one-eyed-alien.net>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 05 Sep 2013 09:26:35 +0200
In-Reply-To: <1378121129-32594-5-git-send-email-kraxel@redhat.com>
References: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
	 <1378121129-32594-5-git-send-email-kraxel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 13:25 +0200, Gerd Hoffmann wrote:
> +static void uas_zap_dead(struct uas_dev_info *devinfo)
> +{
> +       struct uas_cmd_info *cmdinfo;
> +       struct uas_cmd_info *temp;
> +       struct list_head list;
> +       unsigned long flags;
> +
> +       spin_lock_irq(&uas_lists_lock);
> +       list_replace_init(&uas_dead_list, &list);
> +       spin_unlock_irq(&uas_lists_lock);

This looks like a window for a race.

> +       spin_lock_irqsave(&devinfo->lock, flags);
> +       list_for_each_entry_safe(cmdinfo, temp, &list, dead) {
> +  

What happens if list entries are on the private list, when
the function is called for another device? It looks to me like
the di==devinfo test could put them back on the list although
they would need to be canceled.

	Regards
		Oliver


