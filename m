Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbaFQJLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:11:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:42546 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaFQJLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:11:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,493,1400050800"; 
   d="scan'208";a="556682970"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/2] lib.c: skip --param parameters
Date: Tue, 17 Jun 2014 12:11:46 +0300
Message-Id: <1402996306-6811-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1402996306-6811-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very dumb patch to just skip --param allow-store-data-races=0 introduced in
newer GCC versions.

Without this patch sparse recognizes parameter of the --param option as a file
name which obviously couldn't be found.

The patch for easy implementation's sake slightly changed behaviour of
--version. Instead of exact keyword it will recognize anything starting with
--version as a correct option.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/lib.c b/lib.c
index 4e5a846..d5b94c3 100644
--- a/lib.c
+++ b/lib.c
@@ -678,6 +678,18 @@ static char **handle_version(char *arg, char **next)
 	exit(0);
 }
 
+static char **handle_param(char *arg, char **next)
+{
+	const char *value = NULL;
+
+	/* For now just skip any '--param=*' or '--param *' */
+	value = split_value_from_arg(arg, value);
+	if (!value)
+		++next;
+
+	return ++next;
+}
+
 struct switches {
 	const char *name;
 	char **(*fn)(char *, char **);
@@ -686,13 +698,14 @@ struct switches {
 static char **handle_long_options(char *arg, char **next)
 {
 	static struct switches cmd[] = {
+		{ "param", handle_param },
 		{ "version", handle_version },
 		{ NULL, NULL }
 	};
 	struct switches *s = cmd;
 
 	while (s->name) {
-		if (!strcmp(s->name, arg))
+		if (!strncmp(arg, s->name, strlen(s->name)))
 			return s->fn(arg, next);
 		s++;
 	}
-- 
2.0.0

