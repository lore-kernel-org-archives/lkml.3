Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaJIL0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:26:22 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61188 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007AbaJIL0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:26:13 -0400
Message-ID: <1412853970.21441.32.camel@x220>
Subject: Re: linux-next: Tree for Oct 8 (media/usb/gspca)
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        linux-media <linux-media@vger.kernel.org>
Date: Thu, 09 Oct 2014 13:26:10 +0200
In-Reply-To: <20141009073052.0ddc3e97@recife.lan>
References: <20141008174923.76786a03@canb.auug.org.au>
	 <543570C3.9080207@infradead.org> <20141008153105.2fe82fca@recife.lan>
	 <5435A44D.2050609@infradead.org> <20141008225011.2d034c1e@recife.lan>
	 <1412837128.21441.9.camel@x220> <20141009073052.0ddc3e97@recife.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2014 11:26:10.0887 (UTC) FILETIME=[D3C94D70:01CFE3B3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 07:30 -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 09 Oct 2014 08:45:28 +0200
> Paul Bolle <pebolle@tiscali.nl> escreveu:
> > The above discussion meanders a bit, and I just stumbled onto it, but
> > would
> >     #if IS_BUILTIN(CONFIG_INPUT) || (IS_MODULE(CONFIG_INPUT) && defined(MODULE))
> > 
> > cover your requirements when using macros?
> 
> No. What we need to do, for all gspca sub-drivers that have optional
> support for buttons is to only enable the buttons support if:
> 
> 	CONFIG_INPUT=y
> or
> 	CONFIG_INPUT=m and CONFIG_USB_GSPCA_submodule=m
> 
> If we use a reverse logic, we need to disable the code if:
> 	# CONFIG_INPUT is not set
> or
> 	CONFIG_INPUT=m and CONFIG_USB_GSPCA_submodule=y
> 
> The rationale for disabling the code on the last expression is that a
> builtin code cannot call a function inside a module.
> 
> Also, as the submodule is already being compiled, we know that
> CONFIG_USB_GSPCA_submodule is either module or builtin.
> 
> So, either one of those expressions should work:
> 	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && !IS_BUILTIN(CONFIG_USB_GSPCA_submodule))
> or
> 	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_MODULE(CONFIG_INPUT) && IS_MODULE(CONFIG_USB_GSPCA_submodule) && defined(MODULE))

I thought MODULE was only defined for code that will be part of a
module. So "IS_MODULE(CONFIG_USB_GSPCA_submodule)" and "defined(MODULE)"
should be equal when used _inside_ [...]/usb/gspca/that_submodule.c,
shouldn't they? That would make this option basically identical to my
suggestion. Or are you thinking about using these tests outside of these
submodules themselves?

> or
> 	#if (IS_BUILTIN(CONFIG_INPUT)) || (IS_ENABLED(CONFIG_INPUT) && IS_MODULE(CONFIG_USB_GSPCA_submodule))

I think it's clearer to use
    IS_BUILTIN(CONFIG_FOO) || (IS_MODULE(CONFIG_FOO) && [...])

Ditto above. Perhaps just a matter of taste.

(Depending on INPUT is apparently not possible for these submodules. So
obviously any solution needs to check whether input is available, say
like
    if (IS_MODULE(CONFIG_INPUT))
        if (!is_input_loaded())
            goto no_input;

Doesn't it?)

Thanks,


Paul Bolle

