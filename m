Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3KULdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:33:53 -0500
Received: from smtp.citrix.com ([66.165.176.89]:39065 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab3KULdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:33:52 -0500
X-IronPort-AV: E=Sophos;i="4.93,743,1378857600"; 
   d="scan'208";a="76748435"
Message-ID: <528DEF9D.4070003@citrix.com>
Date: Thu, 21 Nov 2013 11:33:49 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <Ian.Campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <JBeulich@suse.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is
 not yet up.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> The user can launch the guest in this sequence:
> 
> xl create -p /vm.cfg	[launch, but pause it]
> xl shutdown latest	[sets control/shutdown=poweroff]
> xl unpause latest
> xl console latest	[and see that the guest has completely
> ignored the shutdown request]
> 
> In reality the guest hasn't ignored it. It registers a watch
> and gets a notification that there is value. It then calls
> the shutdown_handler which ends up calling orderly_shutdown.

Is this really a bug?.

>From the xl(1) man page.

  shutdown [OPTIONS] -a|domain-id
     Gracefully shuts down a domain.  This coordinates with the
     domain OS to perform graceful shutdown, so there is no guarantee
     that it will succeed, and may take a variable length of time
     depending on what services must be shutdown in the domain.

Seems like ignoring a shutdown request when the guest cannot yet
shutdown gracefully is the expected behaviour.

This also doesn't seem sufficient.  SYSTEM_RUNNING is set prior to
starting init in an initramfs and orderly_power_off(false) will still
likely fail at this point.

David
