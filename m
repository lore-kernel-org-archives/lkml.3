Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaIQKfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:35:03 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41046 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbaIQKe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:34:59 -0400
X-Sasl-enc: WOZA646MfxO/xCoXdrotW+CMTUZZQMK+yGCuLI9q+HOR 1410950098
Date: Wed, 17 Sep 2014 07:34:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 10/13] eeepc-laptop: compare proper return values in
 get_cpufv
Message-ID: <20140917103446.GA8594@khazad-dum.debian.net>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-11-git-send-email-fransklaver@gmail.com>
 <20140915214902.GB64909@vmdeb7>
 <20140915215125.GA21435@kroah.com>
 <20140915215527.GC7867@gmail.com>
 <CAH6sp9N1y3=LLju85ZHgc05ENUYLgUdYBYpemc6_oNhbsZ+r6g@mail.gmail.com>
 <20140916205247.GA6856@vmdeb7>
 <20140916212715.GB6856@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916212715.GB6856@vmdeb7>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Darren Hart wrote:
> - When reading and writing sysfs device attribute files, avoid dependency
>   on specific error codes wherever possible. This minimizes coupling to
>   the error handling implemementation within the kernel.
> 
>   In general, failures to read or write sysfs device attributes shall
>   propogate errors wherever possible. Common errors include, but are not
>   limited to:
> 
>   -EIO: The read or store operation is not supported, typically returned by
>         the sysfs system itself if the read or store pointer is NULL.
> 
>   -ENXIO: The read or store operation failed

from errno(3):
       EIO             Input/output error (POSIX.1)
       ENXIO           No such device or address (POSIX.1)

It makes sense to retry EIO.  ENXIO means there's nobody listening at the
time, and isn't usually retried.

The device-based interfaces get it right.  A typical example is the
cpu-based devices, where ENXIO means "no such processor", while EIO means
"whatever you're trying to do failed",  so a MSR read would return ENXIO if
the processor core is offline/doesn't exist, and EIO if the processor core
is there, but raised a #GP when the MSR read was attempted.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
