Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab3AOW1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:27:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:41263 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013Ab3AOW1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:27:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <ffainelli@freebox.fr>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [ 045/221] pstore/ram: Fix undefined usage of rounddown_pow_of_two(0)
Date: Tue, 15 Jan 2013 10:49:32 -0800
Message-Id: <20130115185001.268335036@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Bizon <mbizon@freebox.fr>

commit b042e47491ba5f487601b5141a3f1d8582304170 upstream.

record_size / console_size / ftrace_size can be 0 (this is how you disable
the feature), but rounddown_pow_of_two(0) is undefined. As suggested by
Kees Cook, use !is_power_of_2() as a condition to call
rounddown_pow_of_two and avoid its undefined behavior on the value 0. This
issue has been present since commit 1894a253 (ramoops: Move to
fs/pstore/ram.c).

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/pstore/ram.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -374,10 +374,14 @@ static int __devinit ramoops_probe(struc
 		goto fail_out;
 	}
 
-	pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
-	pdata->record_size = rounddown_pow_of_two(pdata->record_size);
-	pdata->console_size = rounddown_pow_of_two(pdata->console_size);
-	pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
+	if (!is_power_of_2(pdata->mem_size))
+		pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
+	if (!is_power_of_2(pdata->record_size))
+		pdata->record_size = rounddown_pow_of_two(pdata->record_size);
+	if (!is_power_of_2(pdata->console_size))
+		pdata->console_size = rounddown_pow_of_two(pdata->console_size);
+	if (!is_power_of_2(pdata->ftrace_size))
+		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
 	cxt->dump_read_cnt = 0;
 	cxt->size = pdata->mem_size;


