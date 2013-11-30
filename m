Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3K3COK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 21:14:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:45812 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab3K3COF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 21:14:05 -0500
Date: Sat, 30 Nov 2013 13:25:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] bugfix for IMA code
Message-ID: <alpine.LRH.2.02.1311301324440.14854@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes another regression in the IMA code.

Please pull.

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Roberto Sassu (1):
      ima: store address of template_fmt_copy in a pointer before calling strsep

 security/integrity/ima/ima_template.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
commit af91706d5ddecb4a9858cca9e90d463037cfd498
Author: Roberto Sassu <roberto.sassu@polito.it>
Date:   Wed Nov 27 14:40:41 2013 +0100

    ima: store address of template_fmt_copy in a pointer before calling strsep
    
    This patch stores the address of the 'template_fmt_copy' variable in a new
    variable, called 'template_fmt_ptr', so that the latter is passed as an
    argument of strsep() instead of the former. This modification is needed
    in order to correctly free the memory area referenced by
    'template_fmt_copy' (strsep() modifies the pointer of the passed string).
    
    Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
    Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
    Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

---

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 913e192..635695f 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -110,7 +110,7 @@ static int template_desc_init_fields(const char *template_fmt,
 				     struct ima_template_field ***fields,
 				     int *num_fields)
 {
-	char *c, *template_fmt_copy;
+	char *c, *template_fmt_copy, *template_fmt_ptr;
 	int template_num_fields = template_fmt_size(template_fmt);
 	int i, result = 0;
 
@@ -127,7 +127,9 @@ static int template_desc_init_fields(const char *template_fmt,
 		result = -ENOMEM;
 		goto out;
 	}
-	for (i = 0; (c = strsep(&template_fmt_copy, "|")) != NULL &&
+
+	template_fmt_ptr = template_fmt_copy;
+	for (i = 0; (c = strsep(&template_fmt_ptr, "|")) != NULL &&
 	     i < template_num_fields; i++) {
 		struct ima_template_field *f = lookup_template_field(c);
 
