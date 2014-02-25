Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaBYQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:56:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57594 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaBYQ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:56:23 -0500
Message-ID: <530CCB0E.3060009@zytor.com>
Date: Tue, 25 Feb 2014 08:55:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com> <1390849071-21989-8-git-send-email-vgoyal@redhat.com> <530B989B.8010507@zytor.com> <20140225164342.GC2701@redhat.com>
In-Reply-To: <20140225164342.GC2701@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 08:43 AM, Vivek Goyal wrote:
> 
> W.r.t sharing the code with arch/x86/boot/, I am not sure how to do it.
> 

Pretty much we have been doing #includes (a bit sad, I know)... there
are already a lot of them between arch/x86/boot,
arch/x86/boot/compressed, and arch/x86/realmode.  In that sense
collecting these "limited environments" together and have these kinds of
stuff together in one place seems like a good idea.

Does purgatory move large amounts of data around?  If so, we probably
*do* want to use rep movsl, but otherwise you're definitely right, using
C code makes more sense.

> I see two implementations of memcpy() under arch/x86/boot.
> 
> One is in copy.S. This is assembly code and looks like is supposed to
> run in 16bit mode. (code16).
> 
> Other one is in compressed/misc.c and there are two definitions, one
> for 32bit and one fore 64bit.

They are basically the 16-, 32-, and 64-bit variants of the same code.

> I am not sure why there is a need to write memcpy() in assembly when
> C will do just fine for my case. I don't have to write two versions of
> memcpy() and use it both for 32bit and 64bit.

The point would be to use the ones we already have.

> So I can just make all the purgatory code share same version of memcpy(),
> memcmp() and memset(), is that fine. I have taken implementations of
> these functions from lib/string.c

It depends on if you care about performance.  For memcpy() and memset()
in particular, the CPU has internally optimized versions of these that
beats C at least on any newer silicon.

	-hpa

