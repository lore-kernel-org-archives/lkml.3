Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3K3LMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 06:12:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60611 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3K3LMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 06:12:17 -0500
Date: Sat, 30 Nov 2013 12:12:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Levente Kurusa <levex@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131130111214.GB4323@pd.tnic>
References: <5298F900.9000208@linux.com>
 <20131129205628.GA20144@pd.tnic>
 <52999419.7040600@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52999419.7040600@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 08:30:33AM +0100, Levente Kurusa wrote:
> No, if the call to put_device gives up the last reference to the
> device, then device_release gets called which in turn frees the memory
> associated with it. In this case, mce_device_release() will get
> called, which is just a simple kfree call.

Aah, that's that delayed freeing the driver core does, right. Now you
made me go and look into detail:

device_unregister
|->put_device
  |->kobject_put
     |->kref_put(&kobj->kref, kobject_release)
	|->kref_sub(kref, 1, release)
	   |->release
	   |->kobject_release
	      |->kobject_cleanup
	         |->t->release
		 |->device_release
		    |->mce_device_release


Ok, I see it now. :-) :-)

Thanks, I'll take your patch as-is.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
