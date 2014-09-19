Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbaISQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:42:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36406 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756107AbaISQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:42:30 -0400
X-Sasl-enc: H3/3rX3okTofvszKVnA2PUIihkZBNaNbQZ3Ew3QrHJtm 1411144949
Date: Fri, 19 Sep 2014 13:42:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140919164217.GD17456@khazad-dum.debian.net>
References: <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as>
 <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net>
 <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com>
 <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919150042.GC5318@nazgul.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014, Borislav Petkov wrote:
> On Fri, Sep 19, 2014 at 07:54:14AM -0500, Chuck Ebbert wrote:
> > 2) Don't allow a late update if TSX is still enabled on those
> > processors.
> 
> Yeah, so the use case I have in mind is when a long-running machine
> wants to apply microcode and this microcode disables CPUID bits and
> instructions. And the machine cannot be rebooted.
> 
> I guess in that case we would have to issue a warning only on the
> affected processors that a rebooted is mandatory and fail the update...
> Maybe something like that.

Well, in this case we'd have to (on Intel, but AMD is likely the same):

1. offline a "guinea pig" group of "cpus", i.e. an entire "microcode update
unit" that doesn't include the BSP.  This is going to be a pain, as what
composes a "microcode update unit" is not set in stone, and could change in
a future microarch.

2. apply the update to one of the "guinea pig" "cpus" (which will update all
"cpus" in the same "microcode update unit").

3. sanity check.

4a. abort the update run if something nasty happened, leaving the "guinea
pig" "cpus" locked offline until the next reboot.  Warn the user.

4b. online the "guinea pig" "cpus" if the update looks good, and proceed to
update the rest of the "cpus" in the system.

We need this dance because we cannot roll-back a microcode update in the
general case.

To me, it looks way too complicated to be worth the effort.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
