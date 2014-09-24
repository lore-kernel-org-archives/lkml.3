Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaIXS7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:59:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58180 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458AbaIXS7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:59:48 -0400
X-Sasl-enc: 1fi8a3diC2S3vsfNMAkt5tZJpQhQGFkElbIkoKu5d6+N 1411585188
Date: Wed, 24 Sep 2014 15:59:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
Message-ID: <20140924185934.GB16214@khazad-dum.debian.net>
References: <20140919110014.GC29639@khazad-dum.debian.net>
 <20140919112953.GA3256@nazgul.tnic>
 <20140919075415.5149d5f2@as>
 <20140919150042.GC5318@nazgul.tnic>
 <20140919164217.GD17456@khazad-dum.debian.net>
 <20140923200054.GB16467@pd.tnic>
 <20140924145658.GB31678@khazad-dum.debian.net>
 <CALCETrU3-iNqCOT7EArtB91zAZC6ChuVN1wF6LbtdUqpoyJ+ig@mail.gmail.com>
 <20140924174557.GD31678@khazad-dum.debian.net>
 <CALCETrXz1aGqqUiczykeHhxSSRhEZ=qnj-RsyFhoz565YTKEpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXz1aGqqUiczykeHhxSSRhEZ=qnj-RsyFhoz565YTKEpw@mail.gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014, Andy Lutomirski wrote:
> We can sort of fudge it if whatever control BIOS uses is available to
> us, too, and we can reprogram it to "enabled" after a microcode update
> disables TSX.

Only for the early initramfs microcode update driver, and that's going to be
useful only as a way to honor the "keep Intel TSX enabled even if it is
badly broken" switch that was added by Intel for developer usage.

For the runtime microcode update (regular microcode driver), an
"enabled->disabled->enabled" transition would still disrupt the system:
triggering a microcode update in a cpu can update other cpus, which might be
running Intel TSX instructions.  Boom! processes running on these other cpus
can crash with SIGILL, and we have data loss.

The microcode update has to preserve the entire [visible] processor state,
otherwise we cannot safely apply it "late".  Intel TSX included.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
