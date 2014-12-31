Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaLaQ7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:59:00 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34976 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaLaQ67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:58:59 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: acpica: utstring.c:  Remove some unused functions
Date: Wed, 31 Dec 2014 18:01:57 +0100
Message-Id: <1420045317-24091-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
acpi_ut_strlwr() acpi_ut_safe_strncat() acpi_ut_safe_strcat()
acpi_ut_safe_strcpy() ut_convert_backslashes() acpi_ut_stricmp()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/acpi/acpica/acutils.h  |   17 -----
 drivers/acpi/acpica/utstring.c |  157 ----------------------------------------
 2 files changed, 174 deletions(-)

diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 486d342..8e082af 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -629,33 +629,16 @@ acpi_ut_get_resource_end_tag(union acpi_operand_object *obj_desc, u8 **end_tag);
  */
 void acpi_ut_strupr(char *src_string);
 
-void acpi_ut_strlwr(char *src_string);
-
-int acpi_ut_stricmp(char *string1, char *string2);
-
 acpi_status acpi_ut_strtoul64(char *string, u32 base, u64 *ret_integer);
 
 void acpi_ut_print_string(char *string, u16 max_length);
 
-void ut_convert_backslashes(char *pathname);
-
 u8 acpi_ut_valid_acpi_name(char *name);
 
 u8 acpi_ut_valid_acpi_char(char character, u32 position);
 
 void acpi_ut_repair_name(char *name);
 
-#if defined (ACPI_DEBUGGER) || defined (ACPI_APPLICATION)
-u8 acpi_ut_safe_strcpy(char *dest, acpi_size dest_size, char *source);
-
-u8 acpi_ut_safe_strcat(char *dest, acpi_size dest_size, char *source);
-
-u8
-acpi_ut_safe_strncat(char *dest,
-		     acpi_size dest_size,
-		     char *source, acpi_size max_transfer_length);
-#endif
-
 /*
  * utmutex - mutex support
  */
diff --git a/drivers/acpi/acpica/utstring.c b/drivers/acpi/acpica/utstring.c
index 6dc54b3..d94d536 100644
--- a/drivers/acpi/acpica/utstring.c
+++ b/drivers/acpi/acpica/utstring.c
@@ -52,71 +52,6 @@ ACPI_MODULE_NAME("utstring")
  * Non-ANSI C library functions - strlwr, strupr, stricmp, and a 64-bit
  * version of strtoul.
  */
-#ifdef ACPI_ASL_COMPILER
-/*******************************************************************************
- *
- * FUNCTION:    acpi_ut_strlwr (strlwr)
- *
- * PARAMETERS:  src_string      - The source string to convert
- *
- * RETURN:      None
- *
- * DESCRIPTION: Convert string to lowercase
- *
- * NOTE: This is not a POSIX function, so it appears here, not in utclib.c
- *
- ******************************************************************************/
-void acpi_ut_strlwr(char *src_string)
-{
-	char *string;
-
-	ACPI_FUNCTION_ENTRY();
-
-	if (!src_string) {
-		return;
-	}
-
-	/* Walk entire string, lowercasing the letters */
-
-	for (string = src_string; *string; string++) {
-		*string = (char)ACPI_TOLOWER(*string);
-	}
-
-	return;
-}
-
-/******************************************************************************
- *
- * FUNCTION:    acpi_ut_stricmp (stricmp)
- *
- * PARAMETERS:  string1             - first string to compare
- *              string2             - second string to compare
- *
- * RETURN:      int that signifies string relationship. Zero means strings
- *              are equal.
- *
- * DESCRIPTION: Implementation of the non-ANSI stricmp function (compare
- *              strings with no case sensitivity)
- *
- ******************************************************************************/
-
-int acpi_ut_stricmp(char *string1, char *string2)
-{
-	int c1;
-	int c2;
-
-	do {
-		c1 = tolower((int)*string1);
-		c2 = tolower((int)*string2);
-
-		string1++;
-		string2++;
-	}
-	while ((c1 == c2) && (c1));
-
-	return (c1 - c2);
-}
-#endif
 
 /*******************************************************************************
  *
@@ -554,95 +489,3 @@ void acpi_ut_repair_name(char *name)
 	}
 }
 
-#if defined ACPI_ASL_COMPILER || defined ACPI_EXEC_APP
-/*******************************************************************************
- *
- * FUNCTION:    ut_convert_backslashes
- *
- * PARAMETERS:  pathname        - File pathname string to be converted
- *
- * RETURN:      Modifies the input Pathname
- *
- * DESCRIPTION: Convert all backslashes (0x5C) to forward slashes (0x2F) within
- *              the entire input file pathname string.
- *
- ******************************************************************************/
-
-void ut_convert_backslashes(char *pathname)
-{
-
-	if (!pathname) {
-		return;
-	}
-
-	while (*pathname) {
-		if (*pathname == '\\') {
-			*pathname = '/';
-		}
-
-		pathname++;
-	}
-}
-#endif
-
-#if defined (ACPI_DEBUGGER) || defined (ACPI_APPLICATION)
-/*******************************************************************************
- *
- * FUNCTION:    acpi_ut_safe_strcpy, acpi_ut_safe_strcat, acpi_ut_safe_strncat
- *
- * PARAMETERS:  Adds a "DestSize" parameter to each of the standard string
- *              functions. This is the size of the Destination buffer.
- *
- * RETURN:      TRUE if the operation would overflow the destination buffer.
- *
- * DESCRIPTION: Safe versions of standard Clib string functions. Ensure that
- *              the result of the operation will not overflow the output string
- *              buffer.
- *
- * NOTE:        These functions are typically only helpful for processing
- *              user input and command lines. For most ACPICA code, the
- *              required buffer length is precisely calculated before buffer
- *              allocation, so the use of these functions is unnecessary.
- *
- ******************************************************************************/
-
-u8 acpi_ut_safe_strcpy(char *dest, acpi_size dest_size, char *source)
-{
-
-	if (ACPI_STRLEN(source) >= dest_size) {
-		return (TRUE);
-	}
-
-	ACPI_STRCPY(dest, source);
-	return (FALSE);
-}
-
-u8 acpi_ut_safe_strcat(char *dest, acpi_size dest_size, char *source)
-{
-
-	if ((ACPI_STRLEN(dest) + ACPI_STRLEN(source)) >= dest_size) {
-		return (TRUE);
-	}
-
-	ACPI_STRCAT(dest, source);
-	return (FALSE);
-}
-
-u8
-acpi_ut_safe_strncat(char *dest,
-		     acpi_size dest_size,
-		     char *source, acpi_size max_transfer_length)
-{
-	acpi_size actual_transfer_length;
-
-	actual_transfer_length =
-	    ACPI_MIN(max_transfer_length, ACPI_STRLEN(source));
-
-	if ((ACPI_STRLEN(dest) + actual_transfer_length) >= dest_size) {
-		return (TRUE);
-	}
-
-	ACPI_STRNCAT(dest, source, max_transfer_length);
-	return (FALSE);
-}
-#endif
-- 
1.7.10.4

