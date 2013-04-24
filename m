Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3DXWau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:50 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45608 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3DXWad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:33 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Peter Korsgaard <jacmet@uclibc.org>
Subject: [PATCH 8/8] kconfig: implement KCONFIG_PROBABILITY for randconfig
Date: Thu, 25 Apr 2013 00:29:55 +0200
Message-Id: <e43956e607692f9b1c710311e4a6591ffba1edf0.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Currently the odds to set each symbol is (rounded):
    booleans:   y: 50%          n: 50%
    tristates:  y: 33%  m: 33%  n: 33%

Introduce a KCONFIG_PROBABILITY environment variable to tweak the
probabilities (in percentage), as such:
    KCONFIG_PROBABILITY     y:n split           y:m:n split
    -----------------------------------------------------------------
[1] unset or empty          50  : 50            33  : 33  : 34
[2] N                        N  : 100-N         N/2 : N/2 : 100-N
    N:M                     N+M : 100-(N+M)      N  :  M  : 100-(N+M)
    N:M:L                    N  : 100-N          M  :  L  : 100-(M+L)

[1] The current behaviour is kept as default, for backward compatibility
[2] The solution initially implemented by Peter for Buildroot, see:
    http://git.buildroot.org/buildroot/commit/?id=3435c1afb5

Signed-off-by: Peter Korsgaard <jacmet@uclibc.org>
[yann.morin.1998@free.fr: add to Documentation/]
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 Documentation/kbuild/kconfig.txt |   27 ++++++++++++++++++
 scripts/kconfig/confdata.c       |   57 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index dbf746b..3f429ed 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -98,6 +98,33 @@ You can set this to the integer value used to seed the RNG, if you want
 to somehow debug the behaviour of the kconfig parser/frontends.
 If not set, the current time will be used.
 
+KCONFIG_PROBABILITY
+--------------------------------------------------
+This variable can be used to skew the probabilities. This variable can
+be unset or empty, or set to three different formats:
+	KCONFIG_PROBABILITY     y:n split           y:m:n split
+	-----------------------------------------------------------------
+	unset or empty          50  : 50            33  : 33  : 34
+	N                        N  : 100-N         N/2 : N/2 : 100-N
+    [1] N:M                     N+M : 100-(N+M)      N  :  M  : 100-(N+M)
+    [2] N:M:L                    N  : 100-N          M  :  L  : 100-(M+L)
+
+where N, M and L are integers (in base 10) in the range [0,100], and so
+that:
+    [1] N+M is in the range [0,100]
+    [2] M+L is in the range [0,100]
+
+Examples:
+	KCONFIG_PROBABILITY=10
+		10% of booleans will be set to 'y', 90% to 'n'
+		5% of tristates will be set to 'y', 5% to 'm', 90% to 'n'
+	KCONFIG_PROBABILITY=15:25
+		40% of booleans will be set to 'y', 60% to 'n'
+		15% of tristates will be set to 'y', 25% to 'm', 60% to 'n'
+	KCONFIG_PROBABILITY=10:15:15
+		10% of booleans will be set to 'y', 90% to 'n'
+		15% of tristates will be set to 'y', 15% to 'm', 70% to 'n'
+
 ______________________________________________________________________
 Environment variables for 'silentoldconfig'
 
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 8927480..fc45fc1 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1107,7 +1107,51 @@ static void set_all_choice_values(struct symbol *csym)
 void conf_set_all_new_symbols(enum conf_def_mode mode)
 {
 	struct symbol *sym, *csym;
-	int i, cnt;
+	int i, cnt, pby, pty, ptm;	/* pby: probability of boolean  = y
+					 * pty: probability of tristate = y
+					 * ptm: probability of tristate = m
+					 */
+
+	pby = 50; pty = ptm = 33; /* can't go as the default in switch-case
+				   * below, otherwise gcc whines about
+				   * -Wmaybe-uninitialized */
+	if (mode == def_random) {
+		int n, p[3];
+		char *env = getenv("KCONFIG_PROBABILITY");
+		n = 0;
+		while( env && *env ) {
+			char *endp;
+			int tmp = strtol( env, &endp, 10 );
+			if( tmp >= 0 && tmp <= 100 ) {
+				p[n++] = tmp;
+			} else {
+				errno = ERANGE;
+				perror( "KCONFIG_PROBABILITY" );
+				exit( 1 );
+			}
+			env = (*endp == ':') ? endp+1 : endp;
+			if( n >=3 ) {
+				break;
+			}
+		}
+		switch( n ) {
+		case 1:
+			pby = p[0]; ptm = pby/2; pty = pby-ptm;
+			break;
+		case 2:
+			pty = p[0]; ptm = p[1]; pby = pty + ptm;
+			break;
+		case 3:
+			pby = p[0]; pty = p[1]; ptm = p[2];
+			break;
+		}
+
+		if( pty+ptm > 100 ) {
+			errno = ERANGE;
+			perror( "KCONFIG_PROBABILITY" );
+			exit( 1 );
+		}
+	}
 
 	for_all_symbols(i, sym) {
 		if (sym_has_value(sym) || (sym->flags & SYMBOL_VALID))
@@ -1126,8 +1170,15 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 				sym->def[S_DEF_USER].tri = no;
 				break;
 			case def_random:
-				cnt = sym->type == S_TRISTATE ? 3 : 2;
-				sym->def[S_DEF_USER].tri = (tristate)(rand() % cnt);
+				sym->def[S_DEF_USER].tri = no;
+				cnt = rand() % 100;
+				if (sym->type == S_TRISTATE) {
+					if (cnt < pty)
+						sym->def[S_DEF_USER].tri = yes;
+					else if (cnt < (pty+ptm))
+						sym->def[S_DEF_USER].tri = mod;
+				} else if (cnt < pby)
+					sym->def[S_DEF_USER].tri = yes;
 				break;
 			default:
 				continue;
-- 
1.7.10.4

