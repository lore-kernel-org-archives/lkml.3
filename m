Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3HVHPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:15:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60578 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3HVHPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:15:22 -0400
X-IronPort-AV: E=Sophos;i="4.89,932,1367971200"; 
   d="scan'208";a="44275597"
Message-ID: <1377155718.31937.79.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 22 Aug 2013 08:15:18 +0100
In-Reply-To: <9a4bcff8-932e-4f32-b64f-469d174e82b3@email.android.com>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
	 <1376425904.9273.25.camel@hastur.hellion.org.uk>
	 <20130813205332.GA10243@phenom.dumpdata.com>
	 <1376427570.9273.39.camel@hastur.hellion.org.uk>
	 <1376432405.9273.54.camel@hastur.hellion.org.uk>
	 <20130814001050.GA10492@phenom.dumpdata.com>
	 <1376464556.9273.75.camel@hastur.hellion.org.uk>
	 <20130814124647.GD10764@phenom.dumpdata.com>
	 <1376577638.9273.188.camel@hastur.hellion.org.uk>
	 <20130820193507.GI12037@phenom.dumpdata.com>
	 <1377076513.31937.22.camel@hastur.hellion.org.uk>
	 <9a4bcff8-932e-4f32-b64f-469d174e82b3@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-21 at 06:44 -0400, Konrad Rzeszutek Wilk wrote:
> Ian Campbell <ian.campbell@citrix.com> wrote:
> >On Tue, 2013-08-20 at 15:35 -0400, Konrad Rzeszutek Wilk wrote:
> >>  void xen_raw_console_write(const char *str)
> >>  {
> >> -	dom0_write_console(0, str, strlen(str));
> >> +	ssize_t len = strlen(str);
> >> +	int rc = 0;
> >> +
> >> +	if (xen_domain()) {
> >> +		rc = dom0_write_console(0, str, len);
> >> +		if (rc != len && xen_hvm_domain()) /* -ENOSYS */
> >
> >If you want to catch ENOSYS then I suggest doing so explicitly, rather
> >that relying on len != -ENOSYS.
> >
> >> +			goto outb_print;
> >
> >How about reversing this into
> >	if (rc == len) return;
> >	if (rc != -ENOSYS) panic(...) /* yes, this won't get far... *.
> >
> >Then fall through to the following block as a plain if not an else if.
> >Maybe with a xen_hvm_domain && added.
> >
> >That avoids the yucky goto I think.
> >
> >> +	} else if (xen_cpuid_base()) {
> >> +		int i;
> >> +outb_print:
> >> +		for (i = 0; i < len; i++)
> >> +			outb(str[i], 0xe9);
> >> +	}
> >>  }
> >>  
> >>  void xen_raw_printk(const char *fmt, ...)
> 
> B/c the function  dom0_write_console never returns negative values.
> Instead it converts it to a zero return value. Perhaps it can return
> negative values -  will have to look. 

At least the virtio_console version of the hv_ops.put_chars hook can
return -errno. Perhaps this has changed since it was implemented.

Ian.

