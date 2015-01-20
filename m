Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbbATVt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:49:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47896 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbbATVtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:49:24 -0500
Date: Tue, 20 Jan 2015 22:49:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Subject: Re: [PATCH] bluetooth: Add hci_h4p driver
Message-ID: <20150120214922.GA21262@amd>
References: <20141223130219.GA5731@amd>
 <20150120082850.GA27162@t440s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120082850.GA27162@t440s.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-20 10:28:50, Johan Hedberg wrote:
> Hi Pavel,
> 
> On Tue, Dec 23, 2014, Pavel Machek wrote:
> > +	while (1) {
> > +		int cmd, len;
> > +
> > +		fw_pos += cmd_len;
> > +
> > +		if (fw_pos >= fw_entry->size)
> > +			break;
> > +
> > +		if (fw_pos + 2 > fw_entry->size) {
> > +			dev_err(info->dev, "Corrupted firmware image\n");
> > +			err = -EMSGSIZE;
> > +			break;
> > +		}
> > +
> > +		cmd_len = fw_entry->data[fw_pos++];
> > +		cmd_len += fw_entry->data[fw_pos++] << 8;
> > +		if (cmd_len == 0)
> > +			break;
> > +
> > +		if (fw_pos + cmd_len > fw_entry->size) {
> > +			dev_err(info->dev, "Corrupted firmware image\n");
> > +			err = -EMSGSIZE;
> > +			break;
> > +		}
> > +
> > +		/* Skip first two packets */
> > +		if (++num <= 2)
> > +			continue;
> > +
> > +		/* Note that this is timing-critical. If sending packets takes too
> > +		 * long, initialization will fail.
> > +		 */
> > +		cmd = fw_entry->data[fw_pos+1];
> > +		cmd += fw_entry->data[fw_pos+2] << 8;
> > +		len = fw_entry->data[fw_pos+3];
> > +
> > +		skb = __hci_cmd_sync(info->hdev, cmd, len, fw_entry->data+fw_pos+4, 500);
> > +		if (IS_ERR(skb)) {
> > +			dev_err(info->dev, "...sending cmd %x len %d failed %ld\n",
> > +				cmd, len, PTR_ERR(skb));
> > +			err = -EIO;
> > +			break;
> > +		}
> > +	}
> 
> Looks like the code is leaking skb when __hci_cmd_sync() succeeds.

Fixed, thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
