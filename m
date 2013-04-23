Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3DWDNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 23:13:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63483 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3DWDNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 23:13:40 -0400
X-Spam-Score: -100.8
Message-ID: <5175FC36.4060308@asianux.com>
Date: Tue, 23 Apr 2013 11:12:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "paulus@samba.org" <paulus@samba.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: [PATCH] PowerPC: kernel: memory access violation when rtas_data_buf
 contents are more than 1026
References: <516F7A7D.60206@asianux.com> <1366677081.2886.7.camel@pasglop> <5175E85F.1040509@asianux.com>
In-Reply-To: <5175E85F.1040509@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


need set '\0' for 'local_buffer'.

SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096. so the contents of
rtas_data_buf may truncated in memcpy.

if contents are really truncated.
  the splpar_strlen is more than 1026. the next while loop checking will
  not find the end of buffer. that will cause memory access violation.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/powerpc/kernel/lparcfg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 801a757..d92f387 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -299,6 +299,7 @@ static void parse_system_parameter_string(struct seq_file *m)
 				__pa(rtas_data_buf),
 				RTAS_DATA_BUF_SIZE);
 	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (call_status != 0) {
-- 
1.7.7.6
