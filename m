Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaALTlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:41:05 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61825 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaALTlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:41:03 -0500
Date: Sun, 12 Jan 2014 11:40:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel@vger.kernel.org, input-tools@lists.freedesktop.org
Subject: Re: [PATCH 1/4] Input: uinput: add full absinfo support
Message-ID: <20140112194057.GD13131@core.coreip.homeip.net>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
 <1387295334-1744-2-git-send-email-dh.herrmann@gmail.com>
 <20131218222732.GA6315@yabbi.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218222732.GA6315@yabbi.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:27:32AM +1000, Peter Hutterer wrote:
> On Tue, Dec 17, 2013 at 04:48:51PM +0100, David Herrmann wrote:
> > +
> > +	user_dev2->version = UINPUT_VERSION;
> > +	memcpy(user_dev2->name, user_dev->name, UINPUT_MAX_NAME_SIZE);
> > +	memcpy(&user_dev2->id, &user_dev->id, sizeof(struct input_id));
> 
> you copy the id bits one-by-one into the input_dev but you memcpy it here.
> is this intentional?

That should simply be:

	user_dev2->id = user_dev->id;

and in othe rplace as well I think.

> 
> > +	user_dev2->ff_effects_max = user_dev->ff_effects_max;
> > +
> > +	for (i = 0; i < ABS_CNT; ++i) {
> > +		user_dev2->abs[i].value = 0;
> > +		user_dev2->abs[i].maximum = user_dev->absmax[i];
> > +		user_dev2->abs[i].minimum = user_dev->absmin[i];
> > +		user_dev2->abs[i].fuzz = user_dev->absfuzz[i];
> > +		user_dev2->abs[i].flat = user_dev->absflat[i];
> > +		user_dev2->abs[i].resolution = 0;
> > +	}
> > +
> > +	retval = uinput_setup_device(udev, user_dev2, ABS_CNT);
> >  
> > - exit:
> >  	kfree(user_dev);
> > -	return retval;
> > +	kfree(user_dev2);
> > +
> > +	return retval ? retval : count;
> > +}
> > +
> > +static int uinput_setup_device2(struct uinput_device *udev,
> > +			       const char __user *buffer, size_t count)
> > +{
> > +	struct uinput_user_dev2	*user_dev2;
> > +	int			retval;
> > +	size_t			off, abscnt, max;
> > +
> > +	/* The first revision of "uinput_user_dev2" is bigger than
> > +	 * "uinput_user_dev" and growing. Disallow any smaller payloads. */
> > +	if (count <= sizeof(struct uinput_user_dev))
> > +		return -EINVAL;
> > +
> > +	/* rough check to avoid huge kernel space allocations */
> > +	max = ABS_CNT * sizeof(*user_dev2->abs) + sizeof(*user_dev2);
> > +	if (count > max)
> > +		return -EINVAL;
> > +
> > +	user_dev2 = memdup_user(buffer, count);
> > +	if (IS_ERR(user_dev2))
> > +		return PTR_ERR(user_dev2);
> > +
> > +	if (user_dev2->version > UINPUT_VERSION) {
> > +		retval = -EINVAL;
> > +	} else {
> > +		off = offsetof(struct uinput_user_dev2, abs);
> > +		abscnt = (count - off) / sizeof(*user_dev2->abs);
> > +		retval = uinput_setup_device(udev, user_dev2, abscnt);
> > +	}
> > +
> 
> I really wish uinput would be a bit easier to debug than just returning
> -EINVAL when it's not happy. having said that, the only errno that would
> remotely make sense is -ERANGE for count > max and even that is a bit meh.

Maybe we should add a few dev_dbg() and rely on having dynamic debug to
activate logging on demand?

Thanks.

-- 
Dmitry
