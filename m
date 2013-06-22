Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423599Ab3FVB5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 21:57:18 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:41658 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422978Ab3FVB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 21:57:17 -0400
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
To: William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lijo Antony <lijo.kernel@gmail.com>
Cc: speakup@braille.uwo.ca, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
Date: Fri, 21 Jun 2013 22:54:40 -0300
Message-Id: <1371866080-13752-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, there is no need to use strcmp since we can make a test of similar semantic by using the var_id field of param.
I moved the test into the VAR_NUM:VAR_TIME case since VAR_STRING will never be "voice".

spk_xlate isn't used anymore (in line 608), then there is no difference between using cp and buf in VAR_STRING case.
Besides, buf is a const char and those changes remove one uneeded line.

I created the function spk_reset_default_value because it clarifies the code and allows code reusing.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
---
 drivers/staging/speakup/kobjects.c |   73 +++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index 943b6c1..4660ce3 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -585,6 +585,25 @@ ssize_t spk_var_show(struct kobject *kobj, struct kobj_attribute *attr,
 }
 EXPORT_SYMBOL_GPL(spk_var_show);
 
+/*
+ * Used to reset either default_pitch or default_vol.
+ */
+static inline void spk_reset_default_value(char *header_name,
+					int *synth_default_value, int idx)
+{
+	struct st_var_header *param;
+
+	if (synth && synth_default_value) {
+		param = spk_var_header_by_name(header_name);
+		if (param)  {
+			spk_set_num_var(synth_default_value[idx],
+					param, E_NEW_DEFAULT);
+			spk_set_num_var(0, param, E_DEFAULT);
+			pr_info("%s reset to default value\n", param->name);
+		}
+	}
+}
+
 /*
  * This function is called when a user echos a value to one of the
  * variable parameters.
@@ -624,56 +643,44 @@ ssize_t spk_var_store(struct kobject *kobj, struct kobj_attribute *attr,
 		if (ret == -ERANGE) {
 			var_data = param->data;
 			pr_warn("value for %s out of range, expect %d to %d\n",
-				attr->attr.name,
+				param->name,
 				var_data->u.n.low, var_data->u.n.high);
 		}
+
+	       /*
+		* If voice was just changed, we might need to reset our default
+		* pitch and volume.
+		*/
+		if (param->var_id == VOICE) {
+			spk_reset_default_value("pitch", synth->default_pitch,
+				value);
+			spk_reset_default_value("vol", synth->default_vol,
+				value);
+		}
 		break;
 	case VAR_STRING:
-		len = strlen(buf);
-		if ((len >= 1) && (buf[len - 1] == '\n'))
+		len = strlen(cp);
+		if ((len >= 1) && (cp[len - 1] == '\n'))
 			--len;
-		if ((len >= 2) && (buf[0] == '"') && (buf[len - 1] == '"')) {
-			++buf;
+		if ((len >= 2) && (cp[0] == '"') && (cp[len - 1] == '"')) {
+			++cp;
 			len -= 2;
 		}
-		cp = (char *) buf;
 		cp[len] = '\0';
-		ret = spk_set_string_var(buf, param, len);
+		ret = spk_set_string_var(cp, param, len);
 		if (ret == -E2BIG)
 			pr_warn("value too long for %s\n",
-					attr->attr.name);
+					param->name);
 		break;
 	default:
 		pr_warn("%s unknown type %d\n",
 			param->name, (int)param->var_type);
-	break;
-	}
-	/*
-	 * If voice was just changed, we might need to reset our default
-	 * pitch and volume.
-	 */
-	if (strcmp(attr->attr.name, "voice") == 0) {
-		if (synth && synth->default_pitch) {
-			param = spk_var_header_by_name("pitch");
-			if (param)  {
-				spk_set_num_var(synth->default_pitch[value],
-						param, E_NEW_DEFAULT);
-				spk_set_num_var(0, param, E_DEFAULT);
-			}
-		}
-		if (synth && synth->default_vol) {
-			param = spk_var_header_by_name("vol");
-			if (param)  {
-				spk_set_num_var(synth->default_vol[value],
-						param, E_NEW_DEFAULT);
-				spk_set_num_var(0, param, E_DEFAULT);
-			}
-		}
-	}
+		break;
+	}
 	spk_unlock(flags);
 
 	if (ret == -ERESTART)
-		pr_info("%s reset to default value\n", attr->attr.name);
+		pr_info("%s reset to default value\n", param->name);
 	return count;
 }
 EXPORT_SYMBOL_GPL(spk_var_store);
-- 
1.7.2.5

