Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaEBLUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:20:38 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:36070 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaEBLUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:20:37 -0400
Date: Fri, 2 May 2014 13:20:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.15-rc4
Message-ID: <20140502132029.0fea742b@mschwide>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050211-1948-0000-0000-000008A87083
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Two bug fixes, one to fix a potential information leak in the BPF jit
and common-io-layer fix for old firmware levels.

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Sebastian Ott (1):
      s390/chsc: fix SEI usage on old FW levels

 arch/s390/net/bpf_jit_comp.c |    1 -
 drivers/s390/cio/chsc.c      |   22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 9c36dc3..452d3eb 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -276,7 +276,6 @@ static void bpf_jit_noleaks(struct bpf_jit *jit, struct sock_filter *filter)
 	case BPF_S_LD_W_IND:
 	case BPF_S_LD_H_IND:
 	case BPF_S_LD_B_IND:
-	case BPF_S_LDX_B_MSH:
 	case BPF_S_LD_IMM:
 	case BPF_S_LD_MEM:
 	case BPF_S_MISC_TXA:
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 9f0ea6c..e3bf885 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -541,18 +541,27 @@ static void chsc_process_sei_nt0(struct chsc_sei_nt0_area *sei_area)
 
 static void chsc_process_event_information(struct chsc_sei *sei, u64 ntsm)
 {
-	do {
+	static int ntsm_unsupported;
+
+	while (true) {
 		memset(sei, 0, sizeof(*sei));
 		sei->request.length = 0x0010;
 		sei->request.code = 0x000e;
-		sei->ntsm = ntsm;
+		if (!ntsm_unsupported)
+			sei->ntsm = ntsm;
 
 		if (chsc(sei))
 			break;
 
 		if (sei->response.code != 0x0001) {
-			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
-				      sei->response.code);
+			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x, ntsm=%llx)\n",
+				      sei->response.code, sei->ntsm);
+
+			if (sei->response.code == 3 && sei->ntsm) {
+				/* Fallback for old firmware. */
+				ntsm_unsupported = 1;
+				continue;
+			}
 			break;
 		}
 
@@ -568,7 +577,10 @@ static void chsc_process_event_information(struct chsc_sei *sei, u64 ntsm)
 			CIO_CRW_EVENT(2, "chsc: unhandled nt: %d\n", sei->nt);
 			break;
 		}
-	} while (sei->u.nt0_area.flags & 0x80);
+
+		if (!(sei->u.nt0_area.flags & 0x80))
+			break;
+	}
 }
 
 /*

