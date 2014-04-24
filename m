Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaDXENm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:13:42 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:32833 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDXENk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
From: comex <comexk@gmail.com>
Date: Thu, 24 Apr 2014 00:13:18 -0400
Message-ID: <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 6:47 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> This is a prototype of espfix for the 64-bit kernel.  espfix is a
> workaround for the architectural definition of IRET, which fails to
> restore bits [31:16] of %esp when returning to a 16-bit stack
> segment.  We have a workaround for the 32-bit kernel, but that
> implementation doesn't work for 64 bits.

Hi,

A comment: The main purpose of espfix is to prevent attackers from
learning sensitive addresses, right?  But as far as I can tell, this
mini-stack becomes itself somewhat sensitive:

- The user can put arbitrary data in registers before returning to the
LDT in order to get it saved at a known address accessible from the
kernel.  With SMAP and KASLR this might otherwise be difficult.
- If the iret faults, kernel addresses will get stored there (and not
cleared).  If a vulnerability could return data from an arbitrary
specified address to the user, this would be harmful.

I guess with the current KASLR implementation you could get the same
effects via brute force anyway, by filling up and browsing memory,
respectively, but ideally there wouldn't be any virtual addresses
guaranteed not to fault.

- If a vulnerability allowed overwriting data at an arbitrary
specified address, the exception frame could get overwritten at
exactly the right moment between the copy and iret (or right after the
iret to mess up fixup_exception)?  You probably know better than I
whether or not caches prevent this from actually being possible.

Just raising the issue.
