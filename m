Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbaISQyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:54:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36441 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbaISQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:54:17 -0400
X-Sasl-enc: q+p08eS3KGp4rMdhLiai0WR85zin90ZygRApacEfZyr7 1411145656
Date: Fri, 19 Sep 2014 13:54:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919165405.GE17456@khazad-dum.debian.net>
References: <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <CALCETrUaYzBq68gGK7ixdb348jc_c=aKj6rA1=9t=3V3mm=fFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUaYzBq68gGK7ixdb348jc_c=aKj6rA1=9t=3V3mm=fFw@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014, Andy Lutomirski wrote:
> Can we change the ucode blob format for these firmwares so that old
> kernels won't apply them?  I have no other good ideas.  The trouble is
> that distros *should* push out the new ucode, but only if there's some
> guarantee that they'll only be applied early, never late.

All it takes is to rm the /lib/firmware/intel-ucode/<haswell f-m-s> files,
while not touching the microcode you will add to the early initramfs.

Anyway, if you want to fix this through the stable kernel updates:

The intel microcode driver does a "sanity check" pass over all cpus before
the update, attempting to locate the appropriate microcode.  It is trivial
to add the following logic to it:

if cpu_has(hle) && cpuid_in_table(haswell_cpuids) { ignore the microcode }.

You don't even have to key on the current microcode revision, as we don't
know for sure it will be safe to update these processors again when the BIOS
force-enabled HLE anyway.

We can enhance the blacklist to only key on the old microcode that always
enables Intel TSX later, if this proves to be safe.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
