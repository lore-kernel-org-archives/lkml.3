Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3EGOsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:48:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3EGOsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:48:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 01/15] Char: lp, protect LPGETSTATUS with port_mutex
Date: Tue, 7 May 2013 16:48:34 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        "salina@us.ibm.com" <salina@us.ibm.com>, okir@suse.de,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305071648.35039.arnd@arndb.de>
X-Provags-ID: V02:K0:UVmsyRJOyp/sVhn/B7Ewq7Goox+tCMeoyPqkbwIKf9+
 Y9YX/GgjADej90sThIOliF/moxRtlK3usXwMcbj73PbIjvs9Te
 s1NIvYM0YwHxOlECymfgMeTLixZmKraNfsebR6/gmHlYBsP4zT
 F3weGT6o7aXI95IAKC9cbrm0BsC18CPIRFCpFw1ztmuk2WlYNS
 6V5HfxwnSiFpkWyW0R2UL8AboHrAkkt1zvfeCKnkl5FdL2eL3O
 axjl7bPBOJTp5KuHPnY7osCqKWS74qThT3/1lueJG8vNZYtzH3
 Khe8LLta0/9gn19SYWS4gh9159jCYOsLEAO7EoepKmKrBfSS4y
 RP5a9Omz4gZCIXBIeg8Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 May 2013, Jiri Slaby wrote:
> From: "salina@us.ibm.com" <salina@us.ibm.com>
> 
> The patch fixes a problem in the lp driver that can cause oopses as
> follows:
> process A:      calls lp_write, which in turn calls
>                 parport_ieee1284_write_compat, and that invokes
>                 parport_wait_peripheral
> process B:      meanwhile does an ioctl(LPGETSTATUS), which call
>                 lp_release_parport when done. This function will set
>                 physport->cad = NULL.
> process A:      parport_wait_peripheral tries to dereference
>                 physport->cad and dies
> 
> So, protect that code with the port_mutex in order to protect against
> simultaneous calls to lp_read/lp_write.
> 
> Similar protection is probably required for ioctl(LPRESET)...
> 
> This patch was done by IBM a while back and we (at suse) have that
> since at least 2004 in our repos. Let's make it upstream.

Hmm,  it seems the driver has changed a bit since 2004, at least when
I added the lp_mutex to lp_open()/lp_ioctl(). It's probably worth
taking a look at the bigger picture now, to combine lp_mutex with
lp_table[minor].port_mutex. I don't see any reason why we can't always
use the per-device mutex. The only shared variable is the lp_count 
number, and that is not protected under lp_mutex today, and presumably
not updated at run time either.

	Arnd
