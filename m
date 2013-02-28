Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3B1WsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:48:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3B1WsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:48:18 -0500
Date: Thu, 28 Feb 2013 23:48:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jwboyer@redhat.com,
        pjones@redhat.com, vgoyal@redhat.com, mjg59@srcf.ucam.org,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Florian Weimer <fw@deneb.enyo.de>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
In-Reply-To: <30665.1361461678@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1302282335500.2038@twin.jikos.cz>
References: <30665.1361461678@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, David Howells wrote:

> The way we have come up with to get around this is to embed an X.509
> certificate containing the key in a section called ".keylist" in an EFI PE
> binary and then get the binary signed by Microsoft.  The key can then be passed
> to the kernel by passing the signed binary:
> 
> 	keyctl padd asymmetric "" {ID of .system_keyring} <pekey.efi.signed

Please let me take this back to square one for a very short moment.


I completely fail to understand how your security model is dealing with 
this scenario:

- Mr. Evil Blackhat creates EFI PE binary from "int main() { return 42; }" 
  (psuedo)code
- Mr. Evil Blackhat puts his own key into .keylist section of this binary
- Mr. Evil Blackhat goes through the $99 process of having this binary 
  signed by Microsoft. They don't have a slightest reason not to sign it, 
  as the binary obviously can't be used to run backdoored Windows
- Mr. Evil Blackhat then uses keyctl to process this signed binary
- Mr. Evil Blackhat modprobes i_own_your_ring0.ko which is signed by 
  his key, and he instantly has his code running in your SecureBoot 
  environment


Let me formulate my point more clearly -- Microsoft very likely going to 
sign hello world EFI PE binary, no matter the contents of .keylist 
section, as they don't give a damn about this section, as it has zero 
semantic value to them, right?

They sign the binary. By signing the binary, they are *NOT* establishing 
cryptographic chain of trust to the key stored in .keylist, but your 
patchset seems to imply so.

What am I missing?

Thanks,

-- 
Jiri Kosina
SUSE Labs

