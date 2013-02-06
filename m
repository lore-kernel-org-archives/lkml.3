Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3BFTeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:34:18 -0500
Received: from science.horizon.com ([71.41.210.146]:65439 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755439Ab3BFTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:34:17 -0500
Date: 6 Feb 2013 14:34:15 -0500
Message-ID: <20130206193415.10769.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: giometti@enneenne.com, gregkh@linuxfoundation.org, linux@horizon.com,
        peter@hurleysoftware.com
Subject: Re: [PATCH 3/4] pps: Use lookup list to reduce ldisc coupling
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <1360166116-30797-4-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now that N_TTY uses tty->disc_data for its private data,
> 'subclass' ldiscs cannot use ->disc_data for their own private data.
> 
> Use a lookup list to associate the tty with the pps source.

Thanks for the cleanup.  I fully agree my patch was not a good one;
I just wanted someone more experienced to make the call on rearchitecting.

In particular, I was nervous about getting flamed by Linus for something that
was too ambitious.

One thing I'd prefer to do would be to change:

+static struct pps_device *lookup_pps_by_tty(struct tty_struct *tty,
+					    struct pps_data **p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pps_lock, flags);
+	list_for_each_entry((*p), &pps_list, link) {
+		if ((*p)->tty == tty) {
+			spin_unlock_irqrestore(&pps_lock, flags);
+			return (*p)->pps;
+		}
+	}
+	spin_unlock_irqrestore(&pps_lock, flags);
+	return NULL;
+}

to:

static struct pps_data *lookup_pps_by_tty(struct tty_struct *tty)
{
	unsigned long flags;

	spin_lock_irqsave(&pps_lock, flags);
	list_for_each_entry(p, &pps_list, link) {
		if (p->tty == tty)
			break;
	}
	spin_unlock_irqrestore(&pps_lock, flags);
	return p;
}

And do the data->pps dereferencing in the caller.


A more ambitious cleanup would use the existing pps_device list
(maintained to allocate minor device numbers) and add an "owner" field
that can be looked up on, without creating a new data structure and
allocation.

(It could either be a generic "void *", or a "struct device *" and
compare it to tty->dev.)

After all, despite the implementation effort to scale, the total number
of pps devices in a system is usually at most 1 (I have a computer where
I run 2, and I doubt there are many others on the planet who do that.)
