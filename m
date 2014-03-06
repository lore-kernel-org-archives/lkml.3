Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaCFKyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:54:05 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:44665 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaCFKyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:54:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [media] v4l: omap4iss: Add DEBUG compiler flag
Date: Thu, 06 Mar 2014 11:55:31 +0100
Message-ID: <2183657.tkSdBlXoCc@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1394076347.12070.41.camel@joe-AO722>
References: <1391958577.25424.22.camel@x220> <18589524.VtEDRg43uX@avalon> <1394076347.12070.41.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wednesday 05 March 2014 19:25:47 Joe Perches wrote:
> On Thu, 2014-03-06 at 02:52 +0100, Laurent Pinchart wrote:
> > I've thought about that, but it would require iss.h to be included before
> > all other headers. I've also thought about creating an iss-debug.h header
> > to be included first just to #define DEBUG, but decided to go for
> > handling the OMAP4 ISS debug option in the Makefile instead. If that's
> > ugly and discouraged as reported by Mauro I can try to come up with
> > something else.
> 
> Unless debugging logging statements are in system level static inlines,
> adding #define DEBUG to iss.h should otherwise produce the same output
> as -DDEBUG in a Makefile.

dev_dbg() is defined in include/linux/device.h as

#if defined(CONFIG_DYNAMIC_DEBUG)
#define dev_dbg(dev, format, ...)                    \
do {                                                 \
        dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
} while (0)
#elif defined(DEBUG)
#define dev_dbg(dev, format, arg...)            \
        dev_printk(KERN_DEBUG, dev, format, ##arg)
#else
#define dev_dbg(dev, format, arg...)                            \
({                                                              \
        if (0)                                                  \
                dev_printk(KERN_DEBUG, dev, format, ##arg);     \
        0;                                                      \
})
#endif

We thus need the #define DEBUG it appear before the first time device.h is 
included, either directly or indirectly. Adding #define DEBUG to iss.h won't 
work now as iss.h is included after all system includes (which is the usual 
practice, #include <...> come before #include "...").

-- 
Regards,

Laurent Pinchart

