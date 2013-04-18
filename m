Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3DREqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 00:46:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12389 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3DREqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 00:46:33 -0400
X-Spam-Score: -100.8
Message-ID: <516F7A7D.60206@asianux.com>
Date: Thu, 18 Apr 2013 12:45:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: [Suggestion] PowerPC: kernel: memory access violation when rtas_data_buf
 contents are more than 1026
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:


in arch/powerpc/kernel/lparcfg.c, parse_system_parameter_string()

  need set '\0' for 'local_buffer'.

  the reason is:
    SPLPAR_MAXLENGTH is 1026, RTAS_DATA_BUF_SIZE is 4096
    the contents of rtas_data_buf may truncated in memcpy (line 301).

    if contents are truncated.
      the splpar_strlen is more than 1026 (line 321)
      the while loop checking will not find the end of buffer (line 326)
      it will cause memory access violation.


  I find it by reading code, so please help check.

  thanks.

gchen.

-------------------------related fix patch--------------------------------------

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



-------------------------related source code------------------------------------


283 static void parse_system_parameter_string(struct seq_file *m)
284 {
285         int call_status;
286 
287         unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
288         if (!local_buffer) {
289                 printk(KERN_ERR "%s %s kmalloc failure at line %d\n",
290                        __FILE__, __func__, __LINE__);
291                 return;
292         }
293 
294         spin_lock(&rtas_data_buf_lock);
295         memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
296         call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
297                                 NULL,
298                                 SPLPAR_CHARACTERISTICS_TOKEN,
299                                 __pa(rtas_data_buf),
300                                 RTAS_DATA_BUF_SIZE);
301         memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
302         spin_unlock(&rtas_data_buf_lock);
303         
304         if (call_status != 0) {
305                 printk(KERN_INFO
306                        "%s %s Error calling get-system-parameter (0x%x)\n",
307                        __FILE__, __func__, call_status);
308         } else {       
309                 int splpar_strlen;
310                 int idx, w_idx;
311                 char *workbuffer = kzalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
312                 if (!workbuffer) { 
313                         printk(KERN_ERR "%s %s kmalloc failure at line %d\n",
314                                __FILE__, __func__, __LINE__);
315                         kfree(local_buffer);
316                         return;
317                 }       
318 #ifdef LPARCFG_DEBUG
319                 printk(KERN_INFO "success calling get-system-parameter\n");
320 #endif
321                 splpar_strlen = local_buffer[0] * 256 + local_buffer[1];
322                 local_buffer += 2;      /* step over strlen value */
323 
324                 w_idx = 0;
325                 idx = 0;
326                 while ((*local_buffer) && (idx < splpar_strlen)) {
327                         workbuffer[w_idx++] = local_buffer[idx++];
328                         if ((local_buffer[idx] == ',')
329                             || (local_buffer[idx] == '\0')) {
330                                 workbuffer[w_idx] = '\0';
331                                 if (w_idx) {
332                                         /* avoid the empty string */
333                                         seq_printf(m, "%s\n", workbuffer);
334                                 }
335                                 memset(workbuffer, 0, SPLPAR_MAXLENGTH);
336                                 idx++;  /* skip the comma */
337                                 w_idx = 0;
338                         } else if (local_buffer[idx] == '=') {
339                                 /* code here to replace workbuffer contents
340                                    with different keyword strings */
341                                 if (0 == strcmp(workbuffer, "MaxEntCap")) {
342                                         strcpy(workbuffer,
343                                                "partition_max_entitled_capacity");
344                                         w_idx = strlen(workbuffer);
345                                 }
346                                 if (0 == strcmp(workbuffer, "MaxPlatProcs")) {
347                                         strcpy(workbuffer,
348                                                "system_potential_processors");
349                                         w_idx = strlen(workbuffer);
350                                 }
351                         }
352                 }
353                 kfree(workbuffer);
354                 local_buffer -= 2;      /* back up over strlen value */
355         }
356         kfree(local_buffer);
357 }

