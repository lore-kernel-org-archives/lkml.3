Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3AOS5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:57:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:34886 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab3AOS5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabrizio Narni <shibotto@gmail.com>, mus.svz@gmail.com,
        Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [ 042/221] sony-laptop: fix SNC buffer calls when SN06 returns Integers
Date: Tue, 15 Jan 2013 10:49:29 -0800
Message-Id: <20130115185001.059674137@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattia Dongili <malattia@linux.it>

commit dcbeec264d73b7228ffdfe767eab69b2353099b1 upstream.

SN06 in some cases returns an Integer instead of a buffer. While the
code handling the return value was trying to cope with the difference,
the memcpy call was not making any difference between the two types of
acpi_object union. This regression was introduced in 3.5.
While there also rework the return value logic to improve readability.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=48671
Cc: Fabrizio Narni <shibotto@gmail.com>
Cc: <mus.svz@gmail.com>
Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -786,28 +786,29 @@ static int sony_nc_int_call(acpi_handle
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
+	int ret = 0;
 	size_t len = len;
 	union acpi_object *object = __call_snc_method(handle, name, value);
 
 	if (!object)
 		return -EINVAL;
 
-	if (object->type == ACPI_TYPE_BUFFER)
+	if (object->type == ACPI_TYPE_BUFFER) {
 		len = MIN(buflen, object->buffer.length);
+		memcpy(buffer, object->buffer.pointer, len);
 
-	else if (object->type == ACPI_TYPE_INTEGER)
+	} else if (object->type == ACPI_TYPE_INTEGER) {
 		len = MIN(buflen, sizeof(object->integer.value));
+		memcpy(buffer, &object->integer.value, len);
 
-	else {
+	} else {
 		pr_warn("Invalid acpi_object: expected 0x%x got 0x%x\n",
 				ACPI_TYPE_BUFFER, object->type);
-		kfree(object);
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	memcpy(buffer, object->buffer.pointer, len);
 	kfree(object);
-	return 0;
+	return ret;
 }
 
 struct sony_nc_handles {


