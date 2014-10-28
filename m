Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaJ1CWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 22:22:12 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62976 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJ1CWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 22:22:10 -0400
Message-ID: <1414462887.20336.10.camel@debian>
Subject: Re: [PATCH 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
From: Chen Yucong <slaoub@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 Oct 2014 10:21:27 +0800
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32917841@ORSMSX114.amr.corp.intel.com>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
	 <1414371382-15491-3-git-send-email-slaoub@gmail.com>
	 <3908561D78D1C84285E8C5FCA982C28F32917841@ORSMSX114.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 23:10 +0000, Luck, Tony wrote:
> +	m->mcgstatus |= (MCG_STATUS_MCIP|MCG_STATUS_RIPV);
> +	severity = mce_severity(m, mca_cfg.tolerant, NULL);
> 
> This seems a big hack to make mce_severity() work when called from
> CMCI context (when MCG_STATUS register is not set).  It would also
> be confusing as the subsequent logged entries would show MCIP and RIPV
> bits set in the mcg_status.
> 
In fact, I have already noticed this issue from the start. But the 
Intel SDM document that MCIP/RIPV/EIPV are specific to machine check
exception. And I don't know if the above flag bits will be checked in
CMCI context by error log/decode handlers. 

> If someone can think of a less hacky way to do this, that would be good. Otherwise
> the code needs a comment, and should reset m->mcg_status to avoid making logs
> that have incorrect data.
> 
Yes! the above code snippet should be commented. And another method 
that can be used for restoring m->mcgstatus is shown below.

+        u8 mcgs = m->mcgstatus & 0xff;
+
+        m->mcgstatus |= (MCG_STATUS_MCIP|MCG_STATUS_RIPV);
+        severity = mce_severity(m, mca_cfg.tolerant, NULL);
+        m->mcgstatus = (m->mcgstatus & ~0xff) | mcgs;

thx!
cyc

