Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3J1Hr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:47:29 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52813 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3J1Hr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:47:27 -0400
Date: Mon, 28 Oct 2013 08:47:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131028074716.GC6629@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-4-git-send-email-treding@nvidia.com>
 <20131025132553.GE9999@mudshark.cambridge.arm.com>
 <20131026084033.GA14237@gmail.com>
 <20131026140125.GA13424@mudshark.cambridge.arm.com>
 <20131027071237.GA448@gmail.com>
 <20131027100047.GY16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <20131027100047.GY16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: multipart/mixed; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2013 at 10:00:48AM +0000, Russell King - ARM Linux wrote:
> On Sun, Oct 27, 2013 at 08:12:37AM +0100, Ingo Molnar wrote:
> >=20
> > * Will Deacon <will.deacon@arm.com> wrote:
> > > In future, I'll push back on any perf changes outside of arch/ in my=
=20
> > > tree, but that doesn't help us get out of the current situation: the=
=20
> > > patches are currently sitting in rmk's tree for 3.13, so that won't m=
eet=20
> > > with -tip (outside of next) until Linus pulls them both. What can we =
do=20
> > > about that?
> >=20
> > Unless you guys want to do a revert I guess there's not much to do but =
to=20
> > warn Linus in the ARM pull request that a conflict is coming up.
>=20
> From Will's description, it sounded like this could be quite hairy to
> fix up, so I'd like to include the conflict resolution in the pull
> request so Linus has something to refer to if needed.  Could someone
> please forward me that?

Hi Russell,

I've attached the relevant parts of the resolution, although I'm not
sure if anybody's actually confirmed that it's correct. FWIW, if I run

	make tools/perf

I do get the expected output:

	Auto-detecting system features:
	...                     backtrace: [ on  ]
	...                         dwarf: [ on  ]
	...                fortify-source: [ on  ]
	...                         glibc: [ on  ]
	...                          gtk2: [ on  ]
	...                  gtk2-infobar: [ on  ]
	...                      libaudit: [ OFF ]
	...                        libbfd: [ OFF ]
	...                        libelf: [ on  ]
	...             libelf-getphdrnum: [ on  ]
	...                   libelf-mmap: [ on  ]
	...                       libnuma: [ OFF ]
	...                       libperl: [ on  ]
	...                     libpython: [ on  ]
	...             libpython-version: [ OFF ]
	...                      libslang: [ OFF ]
	...                     libunwind: [ on  ]
	...         libunwind-debug-frame: [ OFF ]
	...                       on-exit: [ on  ]
	...                stackprotector: [ on  ]
	...            stackprotector-all: [ on  ]

Which I guess means that the version of libunwind that I have doesn't
enable debug-frame support, but that's as expected according to the
package build script.

Thierry

--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=arm-tip-merge
Content-Transfer-Encoding: quoted-printable

diff --cc tools/perf/config/Makefile
index 75b93d7,c516d6b..e4d06b2
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@@ -29,13 -29,9 +29,13 @@@ ifeq ($(ARCH),x86_64
    NO_PERF_REGS :=3D 0
    LIBUNWIND_LIBS =3D -lunwind -lunwind-x86_64
  endif
 +ifeq ($(ARCH),arm)
 +  NO_PERF_REGS :=3D 0
 +  LIBUNWIND_LIBS =3D -lunwind -lunwind-arm
 +endif
 =20
  ifeq ($(NO_PERF_REGS),0)
-   CFLAGS +=3D -DHAVE_PERF_REGS
+   CFLAGS +=3D -DHAVE_PERF_REGS_SUPPORT
  endif
 =20
  ifeq ($(src-perf),)
@@@ -93,20 -85,125 +89,126 @@@ CFLAGS +=3D -std=3Dgnu9
 =20
  EXTLIBS =3D -lelf -lpthread -lrt -lm -ldl
 =20
- ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-a=
ll,-fstack-protector-all),y)
-   CFLAGS +=3D -fstack-protector-all
+ ifneq ($(OUTPUT),)
+   OUTPUT_FEATURES =3D $(OUTPUT)config/feature-checks/
+   $(shell mkdir -p $(OUTPUT_FEATURES))
  endif
 =20
- ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-=
Wstack-protector),y)
-   CFLAGS +=3D -Wstack-protector
+ feature_check =3D $(eval $(feature_check_code))
+ define feature_check_code
+   feature-$(1) :=3D $(shell $(MAKE) OUTPUT=3D$(OUTPUT_FEATURES) LDFLAGS=
=3D$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && ec=
ho 1 || echo 0)
+ endef
+=20
+ feature_set =3D $(eval $(feature_set_code))
+ define feature_set_code
+   feature-$(1) :=3D 1
+ endef
+=20
+ #
+ # Build the feature check binaries in parallel, ignore errors, ignore ret=
urn value and suppress output:
+ #
+=20
+ #
+ # Note that this is not a complete list of all feature tests, just
+ # those that are typically built on a fully configured system.
+ #
+ # [ Feature tests not mentioned here have to be built explicitly in
+ #   the rule that uses them - an example for that is the 'bionic'
+ #   feature check. ]
+ #
+ CORE_FEATURE_TESTS =3D			\
+ 	backtrace			\
+ 	dwarf				\
+ 	fortify-source			\
+ 	glibc				\
+ 	gtk2				\
+ 	gtk2-infobar			\
+ 	libaudit			\
+ 	libbfd				\
+ 	libelf				\
+ 	libelf-getphdrnum		\
+ 	libelf-mmap			\
+ 	libnuma				\
+ 	libperl				\
+ 	libpython			\
+ 	libpython-version		\
+ 	libslang			\
+ 	libunwind			\
++	libunwind-debug-frame		\
+ 	on-exit				\
+ 	stackprotector			\
+ 	stackprotector-all
+=20
+ #
+ # So here we detect whether test-all was rebuilt, to be able
+ # to skip the print-out of the long features list if the file
+ # existed before and after it was built:
+ #
+ ifeq ($(wildcard $(OUTPUT)config/feature-checks/test-all),)
+   test-all-failed :=3D 1
+ else
+   test-all-failed :=3D 0
+ endif
+=20
+ #
+ # Special fast-path for the 'all features are available' case:
+ #
+ $(call feature_check,all,$(MSG))
+=20
+ #
+ # Just in case the build freshly failed, make sure we print the
+ # feature matrix:
+ #
+ ifeq ($(feature-all), 0)
+   test-all-failed :=3D 1
+ endif
+=20
+ ifeq ($(test-all-failed),1)
+   $(info )
+   $(info Auto-detecting system features:)
+ endif
+=20
+ ifeq ($(feature-all), 1)
+   #
+   # test-all.c passed - just set all the core feature flags to 1:
+   #
+   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
+ else
+   $(shell $(MAKE) OUTPUT=3D$(OUTPUT_FEATURES) LDFLAGS=3D$(LDFLAGS) -i -j =
-C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
+   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
+ endif
+=20
+ #
+ # Print the result of the feature test:
+ #
+ feature_print =3D $(eval $(feature_print_code)) $(info $(MSG))
+=20
+ define feature_print_code
+   ifeq ($(feature-$(1)), 1)
+     MSG =3D $(shell printf '...%30s: [ \033[32mon\033[m  ]' $(1))
+   else
+     MSG =3D $(shell printf '...%30s: [ \033[31mOFF\033[m ]' $(1))
+   endif
+ endef
+=20
+ #
+ # Only print out our features if we rebuilt the testcases or if a test fa=
iled:
+ #
+ ifeq ($(test-all-failed), 1)
+   $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_print,$(feat)))
+   $(info )
  endif
 =20
- ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register=
-var,-Wvolatile-register-var),y)
-   CFLAGS +=3D -Wvolatile-register-var
+ ifeq ($(feature-stackprotector-all), 1)
+   CFLAGS +=3D -fstack-protector-all
+ endif
+=20
+ ifeq ($(feature-stackprotector), 1)
+   CFLAGS +=3D -Wstack-protector
  endif
 =20
- ifndef PERF_DEBUG
-   ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=3D2,-D_=
FORTIFY_SOURCE=3D2),y)
+ ifeq ($(DEBUG),0)
+   ifeq ($(feature-fortify-source), 1)
      CFLAGS +=3D -D_FORTIFY_SOURCE=3D2
    endif
  endif
@@@ -179,64 -274,55 +279,59 @@@ els
  endif # NO_LIBELF
 =20
  ifndef NO_LIBELF
- CFLAGS +=3D -DLIBELF_SUPPORT
- FLAGS_LIBELF=3D$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
- ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-   CFLAGS +=3D -DLIBELF_MMAP
- endif
- ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_G=
ETPHDRNUM),y)
-   CFLAGS +=3D -DHAVE_ELF_GETPHDRNUM
- endif
+   CFLAGS +=3D -DHAVE_LIBELF_SUPPORT
 =20
- # include ARCH specific config
- -include $(src-perf)/arch/$(ARCH)/Makefile
+   ifeq ($(feature-libelf-mmap), 1)
+     CFLAGS +=3D -DHAVE_LIBELF_MMAP_SUPPORT
+   endif
 =20
- ifndef NO_DWARF
- ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-   msg :=3D $(warning DWARF register mappings have not been defined for ar=
chitecture $(ARCH), DWARF support disabled);
-   NO_DWARF :=3D 1
- else
-   CFLAGS +=3D -DDWARF_SUPPORT $(LIBDW_CFLAGS)
-   LDFLAGS +=3D $(LIBDW_LDFLAGS)
-   EXTLIBS +=3D -lelf -ldw
- endif # PERF_HAVE_DWARF_REGS
- endif # NO_DWARF
+   ifeq ($(feature-libelf-getphdrnum), 1)
+     CFLAGS +=3D -DHAVE_ELF_GETPHDRNUM_SUPPORT
+   endif
 =20
- endif # NO_LIBELF
+   # include ARCH specific config
+   -include $(src-perf)/arch/$(ARCH)/Makefile
 =20
- ifndef NO_LIBELF
- CFLAGS +=3D -DLIBELF_SUPPORT
- FLAGS_LIBELF=3D$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
- ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-   CFLAGS +=3D -DLIBELF_MMAP
- endif # try-cc
+   ifndef NO_DWARF
+     ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+       msg :=3D $(warning DWARF register mappings have not been defined fo=
r architecture $(ARCH), DWARF support disabled);
+       NO_DWARF :=3D 1
+     else
+       CFLAGS +=3D -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+       LDFLAGS +=3D $(LIBDW_LDFLAGS)
+       EXTLIBS +=3D -lelf -ldw
+     endif # PERF_HAVE_DWARF_REGS
+   endif # NO_DWARF
  endif # NO_LIBELF
 =20
 -# There's only x86 (both 32 and 64) support for CFI unwind so far
 -ifneq ($(ARCH),x86)
 +ifeq ($(LIBUNWIND_LIBS),)
    NO_LIBUNWIND :=3D 1
  endif
 =20
  ifndef NO_LIBUNWIND
- # for linking with debug library, run like:
- # make DEBUG=3D1 LIBUNWIND_DIR=3D/opt/libunwind/
- ifdef LIBUNWIND_DIR
-   LIBUNWIND_CFLAGS  :=3D -I$(LIBUNWIND_DIR)/include
-   LIBUNWIND_LDFLAGS :=3D -L$(LIBUNWIND_DIR)/lib
- endif
+   #
+   # For linking with debug library, run like:
+   #
+   #   make DEBUG=3D1 LIBUNWIND_DIR=3D/opt/libunwind/
+   #
+   ifdef LIBUNWIND_DIR
+     LIBUNWIND_CFLAGS  :=3D -I$(LIBUNWIND_DIR)/include
+     LIBUNWIND_LDFLAGS :=3D -L$(LIBUNWIND_DIR)/lib
+   endif
 =20
- FLAGS_UNWIND=3D$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLA=
GS) $(EXTLIBS) $(LIBUNWIND_LIBS)
- ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-   msg :=3D $(warning No libunwind found, disabling post unwind support. P=
lease install libunwind-dev[el] >=3D 1.1);
-   NO_LIBUNWIND :=3D 1
- endif # Libunwind support
- ifneq ($(call try-cc,$(SOURCE_LIBUNWIND_DEBUG_FRAME),$(FLAGS_UNWIND),libu=
nwind debug_frame),y)
-   msg :=3D $(warning No debug_frame support found in libunwind);
- CFLAGS +=3D -DNO_LIBUNWIND_DEBUG_FRAME
- endif # debug_frame support in libunwind
- endif # NO_LIBUNWIND
+   ifneq ($(feature-libunwind), 1)
 -    msg :=3D $(warning No libunwind found, disabling post unwind support.=
 Please install libunwind-dev[el] >=3D 0.99);
++    msg :=3D $(warning No libunwind found, disabling post unwind support.=
 Please install libunwind-dev[el] >=3D 1.1);
+     NO_LIBUNWIND :=3D 1
++  else
++    ifneq ($(feature-libunwind-debug-frame), 1)
++      msg :=3D $(warning No debug_frame support found in libunwind);
++      CFLAGS +=3D -DNO_LIBUNWIND_DEBUG_FRAME
++    endif
+   endif
+ endif
 =20
  ifndef NO_LIBUNWIND
-   CFLAGS +=3D -DLIBUNWIND_SUPPORT
+   CFLAGS +=3D -DHAVE_LIBUNWIND_SUPPORT
    EXTLIBS +=3D $(LIBUNWIND_LIBS)
    CFLAGS +=3D $(LIBUNWIND_CFLAGS)
    LDFLAGS +=3D $(LIBUNWIND_LDFLAGS)
diff --cc tools/perf/config/feature-checks/Makefile
index 0000000,452b67c..abaf8f4
mode 000000,100644..100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@@ -1,0 -1,144 +1,148 @@@
+=20
+ FILES=3D					\
+ 	test-all			\
+ 	test-backtrace			\
+ 	test-bionic			\
+ 	test-dwarf			\
+ 	test-fortify-source		\
+ 	test-glibc			\
+ 	test-gtk2			\
+ 	test-gtk2-infobar		\
+ 	test-hello			\
+ 	test-libaudit			\
+ 	test-libbfd			\
+ 	test-liberty			\
+ 	test-liberty-z			\
+ 	test-cplus-demangle		\
+ 	test-libelf			\
+ 	test-libelf-getphdrnum		\
+ 	test-libelf-mmap		\
+ 	test-libnuma			\
+ 	test-libperl			\
+ 	test-libpython			\
+ 	test-libpython-version		\
+ 	test-libslang			\
+ 	test-libunwind			\
++	test-libunwind-debug-frame	\
+ 	test-on-exit			\
+ 	test-stackprotector-all		\
+ 	test-stackprotector
+=20
+ CC :=3D $(CC) -MD
+=20
+ all: $(FILES)
+=20
+ BUILD =3D $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
+=20
+ ###############################
+=20
+ test-all:
+ 	$(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_=
FORTIFY_SOURCE=3D2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit=
 -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2=
>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE=3D'"perf"' =
-lbfd -ldl
+=20
+ test-hello:
+ 	$(BUILD)
+=20
+ test-stackprotector-all:
+ 	$(BUILD) -Werror -fstack-protector-all
+=20
+ test-stackprotector:
+ 	$(BUILD) -Werror -fstack-protector -Wstack-protector
+=20
+ test-fortify-source:
+ 	$(BUILD) -O2 -Werror -D_FORTIFY_SOURCE=3D2
+=20
+ test-bionic:
+ 	$(BUILD)
+=20
+ test-libelf:
+ 	$(BUILD) -lelf
+=20
+ test-glibc:
+ 	$(BUILD)
+=20
+ test-dwarf:
+ 	$(BUILD) -ldw
+=20
+ test-libelf-mmap:
+ 	$(BUILD) -lelf
+=20
+ test-libelf-getphdrnum:
+ 	$(BUILD) -lelf
+=20
+ test-libnuma:
+ 	$(BUILD) -lnuma
+=20
+ test-libunwind:
+ 	$(BUILD) -lunwind -lunwind-x86_64 -lelf
+=20
++test-libunwind-debug-frame:
++	$(BUILD) -lunwind -lunwind-x86_64 -lelf
++
+ test-libaudit:
+ 	$(BUILD) -laudit
+=20
+ test-libslang:
+ 	$(BUILD) -I/usr/include/slang -lslang
+=20
+ test-gtk2:
+ 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+=20
+ test-gtk2-infobar:
+ 	$(BUILD) $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null)
+=20
+ grep-libs  =3D $(filter -l%,$(1))
+ strip-libs =3D $(filter-out -l%,$(1))
+=20
+ PERL_EMBED_LDOPTS =3D $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/nul=
l)
+ PERL_EMBED_LDFLAGS =3D $(call strip-libs,$(PERL_EMBED_LDOPTS))
+ PERL_EMBED_LIBADD =3D $(call grep-libs,$(PERL_EMBED_LDOPTS))
+ PERL_EMBED_CCOPTS =3D `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+ FLAGS_PERL_EMBED=3D$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+=20
+ test-libperl:
+ 	$(BUILD) $(FLAGS_PERL_EMBED)
+=20
+ override PYTHON :=3D python
+ override PYTHON_CONFIG :=3D python-config
+=20
+ escape-for-shell-sq =3D  $(subst ','\'',$(1))
+ shell-sq =3D '$(escape-for-shell-sq)'
+=20
+ PYTHON_CONFIG_SQ =3D $(call shell-sq,$(PYTHON_CONFIG))
+=20
+ PYTHON_EMBED_LDOPTS =3D $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+ PYTHON_EMBED_LDFLAGS =3D $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+ PYTHON_EMBED_LIBADD =3D $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+ PYTHON_EMBED_CCOPTS =3D $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+ FLAGS_PYTHON_EMBED =3D $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+=20
+ test-libpython:
+ 	$(BUILD) $(FLAGS_PYTHON_EMBED)
+=20
+ test-libpython-version:
+ 	$(BUILD) $(FLAGS_PYTHON_EMBED)
+=20
+ test-libbfd:
+ 	$(BUILD) -DPACKAGE=3D'"perf"' -lbfd -ldl
+=20
+ test-liberty:
+ 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE=3D'"perf"' -lbfd -ldl -libe=
rty
+=20
+ test-liberty-z:
+ 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE=3D'"perf"' -lbfd -ldl -libe=
rty -lz
+=20
+ test-cplus-demangle:
+ 	$(BUILD) -liberty
+=20
+ test-on-exit:
+ 	$(BUILD)
+=20
+ test-backtrace:
+ 	$(BUILD)
+=20
+ -include *.d
+=20
+ ###############################
+=20
+ clean:
+ 	rm -f $(FILES) *.d
diff --cc tools/perf/config/feature-checks/test-all.c
index 0000000,50d4318..726be48
mode 000000,100644..100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@@ -1,0 -1,106 +1,110 @@@
+ /*
+  * test-all.c: Try to build all the main testcases at once.
+  *
+  * A well-configured system will have all the prereqs installed, so we ca=
n speed
+  * up auto-detection on such systems.
+  */
+=20
+ /*
+  * Quirk: Python and Perl headers cannot be in arbitrary places, so keep
+  * these 3 testcases at the top:
+  */
+ #define main main_test_libpython
+ # include "test-libpython.c"
+ #undef main
+=20
+ #define main main_test_libpython_version
+ # include "test-libpython-version.c"
+ #undef main
+=20
+ #define main main_test_libperl
+ # include "test-libperl.c"
+ #undef main
+=20
+ #define main main_test_hello
+ # include "test-hello.c"
+ #undef main
+=20
+ #define main main_test_libelf
+ # include "test-libelf.c"
+ #undef main
+=20
+ #define main main_test_libelf_mmap
+ # include "test-libelf-mmap.c"
+ #undef main
+=20
+ #define main main_test_glibc
+ # include "test-glibc.c"
+ #undef main
+=20
+ #define main main_test_dwarf
+ # include "test-dwarf.c"
+ #undef main
+=20
+ #define main main_test_libelf_getphdrnum
+ # include "test-libelf-getphdrnum.c"
+ #undef main
+=20
+ #define main main_test_libunwind
+ # include "test-libunwind.c"
+ #undef main
+=20
++#define main main_test_libunwind_debug_frame
++# include "test-libunwind-debug-frame.c"
++#undef main
++
+ #define main main_test_libaudit
+ # include "test-libaudit.c"
+ #undef main
+=20
+ #define main main_test_libslang
+ # include "test-libslang.c"
+ #undef main
+=20
+ #define main main_test_gtk2
+ # include "test-gtk2.c"
+ #undef main
+=20
+ #define main main_test_gtk2_infobar
+ # include "test-gtk2-infobar.c"
+ #undef main
+=20
+ #define main main_test_libbfd
+ # include "test-libbfd.c"
+ #undef main
+=20
+ #define main main_test_on_exit
+ # include "test-on-exit.c"
+ #undef main
+=20
+ #define main main_test_backtrace
+ # include "test-backtrace.c"
+ #undef main
+=20
+ #define main main_test_libnuma
+ # include "test-libnuma.c"
+ #undef main
+=20
+ int main(int argc, char *argv[])
+ {
+ 	main_test_libpython();
+ 	main_test_libpython_version();
+ 	main_test_libperl();
+ 	main_test_hello();
+ 	main_test_libelf();
+ 	main_test_libelf_mmap();
+ 	main_test_glibc();
+ 	main_test_dwarf();
+ 	main_test_libelf_getphdrnum();
+ 	main_test_libunwind();
+ 	main_test_libaudit();
+ 	main_test_libslang();
+ 	main_test_gtk2(argc, argv);
+ 	main_test_gtk2_infobar(argc, argv);
+ 	main_test_libbfd();
+ 	main_test_on_exit();
+ 	main_test_backtrace();
+ 	main_test_libnuma();
+=20
+ 	return 0;
+ }
diff --cc tools/perf/config/feature-checks/test-libunwind-debug-frame.c
index 0000000,0000000..0ef8087
new file mode 100644
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-libunwind-debug-frame.c
@@@ -1,0 -1,0 +1,16 @@@
++#include <libunwind.h>
++#include <stdlib.h>
++
++extern int
++UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
++				 unw_word_t ip, unw_word_t segbase,
++				 const char *obj_name, unw_word_t start,
++				 unw_word_t end);
++
++#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
++
++int main(void)
++{
++	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
++	return 0;
++}

--kVXhAStRUZ/+rrGn--

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbhaEAAoJEN0jrNd/PrOhwDgP/jRq2kD283RHaU6bYVB2osht
hMnyP2cQNTEUxCR/KEW9ZuRDIe8pu+RkHsEot6CpSkgHcu54a4gASSuLZLE5ptyB
bHbW51OV6+OQYBRbwUq1HtgWuQ+EMZFBKQzoEqo9mC4qqxcW+otG5Ocw1j+z6ssP
fxVqd7umtd9I16IfRGSfSZrSA4KgW+Kt4ddZwmFBEGapIIw8n9yHUibdSW5tk1Zl
ltqeDnZGCBTDxJmVk8j8zEPYNn4uSOMbgI0we7Ib9djOXODTU0ff4s1p5NRoOLGv
o9Um0/d3kc5j+YGIAgp0hfGFmfzP/jHfGOtvcBrAaI6knKFbE0tut999Oj1835hO
ScsqRemJxvKWmVPZG6utsiL+AI7AVJFMs0epCqs+wLFEySxrevieV9MQu/HsxhaM
Rh9wAItajGSyDYfgwtBmxaOJxDyXoKjh7l+v/cbYHbpUT5kHMhSwcgDJoRIaK2mx
UQNswhGiSeOpT6yTeHXeexPYddCiQOvlE50g0c06Y8FBj1MjuFfC+vbwgAt3Ugku
uSPikpDcvoqCcnqiM6R4zQNaQFzdvVO/k3ylOm2K+U6EhhnFyDWuRpA3y3jA0LQ5
WGq4JDV9PzftFw0yo4wqGqnYaTBGs1hErIdUbiCyr3VTE0TcTcoqVIqWhwLVC7rJ
is9jN5Zw/piNJRVp8Y+g
=Owbr
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
