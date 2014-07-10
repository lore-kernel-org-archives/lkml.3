Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaGJSo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:44:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48790 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaGJSoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:44:25 -0400
Date: Thu, 10 Jul 2014 20:44:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
Message-ID: <20140710184416.GE5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
 <20140710164151.GA5603@pd.tnic>
 <CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 11:03:43AM -0700, Havard Skinnemoen wrote:
> For non-shared banks, we might risk some CPUs not being able to
> poll their banks in a long time if they happen to be more or less
> synchronized with a different CPU. This will also get worse with
> shorter polling intervals, and with larger numbers of CPUs.

No, I meant to do something like

	if (atomic_dec_and_test(&mce_banks[i].poll))
		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));

	atomic_add_unless(&mce_banks[i].poll, 1, 1);

so that you have only one CPU read the status register of mce_banks[i].

For non-shared banks, this will always work because no other CPU will
dec that variable anyway.

Or am I missing something...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
